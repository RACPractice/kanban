class Step
  constructor: (params) ->
    @id = params['id']
    @name = ko.observable params['name']
    @position = params['position']
    @removable = params['removable']
    @capacity = ko.observable params['capacity']
    @category = params['category']
    @work_items = ko.observableArray params['work_items'] || []
    @editing = ko.observable false
    @editingCapacity = ko.observable false
    @work_item_textarea = ko.observable ''
    @addWorkItemVisible = ko.observable false

    @work_items.subscribe (param1) =>
      new_positions = ({id: n.id, step_id: @id, position: index} for n, index in @work_items())
      $.ajax(type: 'POST', url: SETTINGS.work_items.update_position_path, data: {work_items: new_positions})
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
          load += parseInt(item.work_value())
      load

    @step_class = ko.computed () =>
      return 'not_sortable' if !@removable
      current_capacity = _.reduce @work_items(), ((sum, wi) => sum + parseInt(wi.work_value())), 0
      return 'exceeded' if current_capacity >= @capacity()
      ''

  addWorkItem: =>
    workItemName= @work_item_textarea()
    $.ajax(type: 'POST', url: SETTINGS.work_items.add_path, data: {work_item: {name: workItemName, step_id: @id, work_value: 0}})
      .done (resp) =>
        @work_items.push new WorkItem({id: resp.id, name: resp.name, description: resp.description, position: resp.position, step_id: resp.step_id, assigned_to: resp.assigned_to, work_value: resp.work_value})
      .fail (error) =>
        bootbox.alert(error.responseText)
    @closeForm()

  showWorkItemForm: =>
    @addWorkItemVisible true

  closeForm: =>
    @work_item_textarea ''
    @addWorkItemVisible false

  editStep: (step, event) =>
    return if !@removable
    @editing true
    setTimeout ()=>
      $(event.target).parent().find('input').focus()
    ,100

  editStepCapacity: (step, event)=>
    return if !@removable
    @editingCapacity true
    setTimeout ()=>
      $(event.target).closest('.editor').find('.editCapacity').focus()
    ,100

  stopEditing: =>
    $.ajax(type: 'PUT', url: SETTINGS.steps.update_path(@id), data: {step: {name: @name}})
      .fail (error) =>
        bootbox.alert(error.responseText)
    @editing false

  stopEditingCapacity: =>
    $.ajax(type: 'PUT', url: SETTINGS.steps.update_path(@id), data: {step: {capacity: @capacity}})
      .fail (error) =>
        bootbox.alert(error.responseText)
    @editingCapacity false

class WorkItem
  constructor: (params) ->
    @id = params['id']
    @name = ko.observable params['name']
    @description = ko.observable params['description']
    @position = params['position']
    @assigned_to = params['assigned_to']
    @step_id = params['step_id']
    @work_value = ko.observable params['work_value']
    @editMode = ko.observable false
    @editPoupClass = ko.computed =>
      if @editMode
        'in'
      else
        ''
    @description_icon = ko.computed =>
      res = ''
      if @description
        res += 'description'
      "/img/work_item_#{res}.png"

    @description_icon_title = ko.computed () =>
      title = ''
      if @description
        title += "Description present"
      title

  toggleWorkItemPopup: =>
    @editMode true

class Membership
  constructor: (params) ->
    @id        = params['id']
    @username  = params['username']
    @role_name = params['role_name']
    @avatar_src = params['avatar_src']

class EditWorkItemDialog
  constructor: (@viewModel) ->
    @name = ko.observable ''
    @description = ko.observable ''
    @open = ko.observable false

class ProjectViewModel
  constructor: ->
    @available_work_values = ko.observableArray(['0', '1', '2', '3'])
    @non_members = []
    @steps = ko.observableArray []
    @memberships = ko.observableArray []
    @account_id = SETTINGS.account_id
    @project_id = SETTINGS.project_id
    @backlog_step = ko.observable new Step {id: -1, name: '', position: 0, removable: false, category: 'backlog', capacity: 0}
    @archive_step = ko.observable new Step {id: -1, name: '', position: 0, removable: false, category: 'archive', capacity: 0}
    @editingWorkItem = ko.observable new WorkItem {id: -1, name: '', position: 0, assigned_to: '', step_id: 0, work_value: 0}
    @newStepInput = ko.observable ''
    @userNameInput = ko.observable ''

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

    $('#userName').autocomplete(source: @non_members)

  addNewStep: =>
    stepName = @newStepInput()
    #save the new project step
    $.ajax(type: 'POST', url: SETTINGS.steps.steps_path, data: {step: {name: stepName}})
      .done (resp) =>
        step = new Step({id: resp.id, name: resp.name, position: resp.position, removable: resp.removable, category: resp.capacity, capacity: resp.capacity})
        @steps.splice(@steps().length - 1, 0, step);
      .fail (error) =>
        bootbox.alert(error.responseText)
    @newStepInput ''

  addNewMember: =>
    username = @userNameInput()
    $.ajax(type: 'POST', url: SETTINGS.memberships.memberships_path, data: {membership: {username: username}})
      .done (resp) =>
        membership = new Membership id: resp.id, username: resp.username, role_name: resp.role_name, avatar_src: resp.avatar_src
        @memberships.push membership
        indexOfUser = @non_members.indexOf(resp.username)
        @non_members.splice(indexOfUser, 1)
      .fail (error) =>
        bootbox.alert(error.responseText)
    @userNameInput ''

  selectWorkItem: (item) =>
    console.log item

  showSteps: =>
    $.getJSON SETTINGS.steps.steps_path, (steps) =>
      $.map steps, (step) =>
          workItems = []
          $.map step.work_items, (w_i) =>
            workItems.push new WorkItem id: w_i.id, name: w_i.name, description: w_i.description, position: w_i.position, assigned_to: w_i.assigned_to, step_id: step.id, work_value: w_i.work_value
          step = new Step id: step.id, name: step.name, position: step.position, removable: step.removable, capacity: step.capacity, category: step.category, work_items: workItems
          if !step.removable
            @backlog_step(step) if step.category == 'backlog'
            @archive_step(step) if step.category == 'archive'
          @steps.push step

  loadMemberships: =>
    $.getJSON SETTINGS.memberships.memberships_path, (resp) =>
      $.map resp.memberships, (membership) =>
        membership = new Membership id: membership.id, username: membership.username, role_name: membership.role_name, avatar_src: membership.avatar_src
        @memberships.push membership
      ko.utils.arrayPushAll(@non_members, resp.non_members)

  deleteStep: (currentStep)=>
    $.ajax(type: 'DELETE', url: SETTINGS.steps.update_path(currentStep.id))
      .done (resp) =>
        @steps.remove(currentStep)
        @updateStepsPositionsOnServer()
        bootbox.alert("Step #{currentStep.name()} successfully deleted.")
      .fail (error) =>
        bootbox.alert(error.responseText)

  updateStepsPositionsOnServer: =>
    new_positions = ({id: n.id, position: index} for n, index in @steps())
    $.ajax(type: 'POST', url: SETTINGS.steps.update_positions, data: {steps: new_positions})

  editStep: =>
    console.log 'Edit'

  editStepCapacity: =>
    console.log 'Edit capacity'

  openEditWorkItemPopup: (workItem) =>
    @editingWorkItem(workItem)
    $('#editWorkItemPopup').modal()
    $('.rating').buttonset()

  updateWorkItem: =>
    $('#editWorkItemPopup').modal 'hide'
    wi = @editingWorkItem()
    $.ajax(type: 'PUT', url: SETTINGS.work_items.update_path(wi.id), data: {work_item : {name: wi.name, description: wi.description, work_value: wi.work_value}})
      .fail (error) =>
        bootbox.alert(error.responseText)

$ ->
  ko.applyBindings new ProjectViewModel()
