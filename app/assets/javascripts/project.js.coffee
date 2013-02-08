class Step
  constructor: (params) ->
    @id = params['id']
    @name = ko.observable params['name']
    @position = params['position']
    @removable = params['removable']
    @capacity = params['capacity']
    @category = params['category']
    @work_items = ko.observableArray params['work_items'] || []
    @editing = ko.observable false

    @work_items.subscribe (param1) =>
      new_positions = ({id: n.id, step_id: @id, position: index} for n, index in @work_items())
      $.ajax(type: 'POST', url: "/work_items/update_positions.json", data: {work_items: new_positions})
    ,@
    ,'positionsChanged'

    @isWorkValueVisible = ko.computed ()=>
      @category != 'archive'
    @isMaxWorkValueVisible = ko.computed ()=>
      @category != 'backlog'
    @currentWorkValue = ko.computed ()=>
      load = 0
      if @work_items().length > 0
        $.map @work_items(), (item) =>
          load += item.work_value
      load

  addWorkItem: =>
    workItemName = $('.work-item-name-for-step-' + @id).val()
    $.ajax(type: 'POST', url: "/work_items.json", data: {work_item: {name: workItemName, step_id: @id, work_value: 1}})
      .done (resp) =>
        @work_items.push new WorkItem({id: resp.id, name: resp.name, description: resp.description, position: resp.position, step_id: resp.step_id, assigned_to: resp.assigned_to, work_value: resp.work_value})
      .fail (error) =>
        bootbox.alert(error.responseText)
    @closeForm()

  showWorkItemForm: =>
    $('.work-item-for-step-' + @id).show()
  closeForm: =>
    $('.work-item-name-for-step-' + @id).val('')
    $('.work-item-for-step-' + @id).hide()
  editStep: (step, event) =>
    return if !@removable
    @editing true
    setTimeout ()=>
      $(event.target).parent().find('input').focus()
    ,100

  stopEditing: =>
    $.ajax(type: 'PUT', url: "/steps/#{@id}.json", data: {step: {name: @name}})
      .fail (error) =>
        bootbox.alert(error.responseText)
    @editing false
  step_class: =>
    if @removable
      ''
    else
      'not_sortable'

class WorkItem
  constructor: (params) ->
    @id = params['id']
    @name = params['name']
    @description = params['description']
    @position = params['position']
    @assigned_to = params['assigned_to']
    @step_id = params['step_id']
    @work_value = params['work_value']

class Membership
  constructor: (params) ->
    @id        = params['id']
    @username  = params['username']
    @role_name = params['role_name']

class ProjectViewModel
  constructor: ->
    @stepNameField = $('#stepName')
    @userNameField = $('#userName')
    @non_members = []
    @steps = ko.observableArray []
    @memberships = ko.observableArray []
    @account_id = ACCOUNT_ID
    @project_id = PROJECT_ID
    @backlog_step = ko.observable new Step({id: -1, name: '', position: 0, removable: false, category: 'backlog', capacity: 0})
    @archive_step = ko.observable new Step({id: -1, name: '', position: 0, removable: false, category: 'archive', capacity: 0})

    @custom_steps = ko.computed ()=>
      ko.utils.arrayFilter @steps(), (item) =>
        item.removable == true

    @stepWidth = ko.computed () =>
      (100 / @steps().length) - 0.5
    ,@

    @containerWidth = ko.computed () =>
      st_length = @steps().length
      st_length * 200 + st_length * 4
    ,@

    @steps.subscribe () =>
      @updateStepsPositionsOnServer()
    ,@
    ,'positionsChanged'

    @showSteps()
    @loadMemberships()

    @userNameField.autocomplete(source: @non_members)

  addNewStep: =>
    stepName = @stepNameField.val()
    #save the new project step
    $.ajax(type: 'POST', url: "/accounts/#{@account_id}/projects/#{@project_id}/steps.json", data: {step: {name: stepName}})
      .done (resp) =>
        step = new Step({id: resp.id, name: resp.name, position: resp.position, removable: resp.removable, category: resp.capacity, capacity: resp.capacity})
        @steps.splice(@steps().length - 1, 0, step);
      .fail (error) =>
        bootbox.alert(error.responseText)
    @stepNameField.val('')

  addNewMember: =>
    username = @userNameField.val()
    $.ajax(type: 'POST', url: "/accounts/#{@account_id}/projects/#{@project_id}/memberships.json", data: {membership: {username: username}})
      .done (resp) =>
        membership = new Membership id: resp.id, username: resp.username, role_name: resp.role_name
        @memberships.push membership
        indexOfUser = @non_members.indexOf(resp.username)
        @non_members.splice(indexOfUser, 1)
      .fail (error) =>
        bootbox.alert(error.responseText)
    @userNameField.val('')

  selectWorkItem: (item) =>
    console.log item

  showSteps: ()=>
    $.getJSON "/accounts/#{@account_id}/projects/#{@project_id}/steps.json", (steps) =>
      $.map steps, (step) =>
          workItems = []
          $.map step.work_items, (w_i) =>
            workItems.push new WorkItem id: w_i.id, name: w_i.name, description: w_i.description, position: w_i.position, assigned_to: w_i.assigned_to, step_id: step.id, work_value: w_i.work_value
          step = new Step id: step.id, name: step.name, position: step.position, removable: step.removable, capacity: step.capacity, category: step.category, work_items: workItems
          if !step.removable
            @backlog_step(step) if step.category == 'backlog'
            @archive_step(step) if step.category == 'archive'
          @steps.push step

  loadMemberships: ()=>
    $.getJSON "/accounts/#{@account_id}/projects/#{@project_id}/memberships.json", (resp) =>
      $.map resp.memberships, (membership) =>
        membership = new Membership id: membership.id, username: membership.username, role_name: membership.role_name
        @memberships.push membership
      ko.utils.arrayPushAll(@non_members, resp.non_members)

  deleteStep: (currentStep)=>
    $.ajax(type: 'DELETE', url: "/steps/#{currentStep.id}.json")
      .done (resp) =>
        @steps.remove(currentStep)
        @updateStepsPositionsOnServer()
        bootbox.alert("Step #{currentStep.name()} successfully deleted.")
      .fail (error) =>
        bootbox.alert(error.responseText)

  updateStepsPositionsOnServer: =>
    new_positions = ({id: n.id, position: index} for n, index in @steps())
    $.ajax(type: 'POST', url: "/steps/update_positions.json", data: {steps: new_positions})

  editStep: =>
    console.log 'Edit'

$ ->
  ko.applyBindings new ProjectViewModel()
