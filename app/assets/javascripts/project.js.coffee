class Step
  constructor: (params) ->
    @id = params['id']
    @name = ko.observable params['name']
    @position = params['position']
    @removable = params['removable']
    @capacity = params['capacity']
    @work_items = ko.observableArray params['work_items']
    @editing = ko.observable false

    @work_items.subscribe (param1) =>
      new_positions = ({id: n.id, step_id: @id, position: index} for n, index in @work_items())
      $.ajax(type: 'POST', url: "/work_items/update_positions.json", data: {work_items: new_positions})
    ,@
    ,'positionsChanged'

  addWorkItem: =>
    workItemName = $('.work-item-name-for-step-' + @id).val()
    $.ajax(type: 'POST', url: "/work_items.json", data: {work_item: {name: workItemName, step_id: @id}})
      .done (resp) =>
        @work_items.push new WorkItem({id: resp.id, name: resp.name, description: resp.description, position: resp.position, step_id: resp.step_id, assigned_to: resp.assigned_to})
      .fail (error) =>
        bootbox.alert(error.responseText)
    @closeForm()

  showWorkItemForm: =>
    $('.work-item-for-step-' + @id).show()
  closeForm: =>
    $('.work-item-name-for-step-' + @id).val('')
    $('.work-item-for-step-' + @id).hide()
  editStep: (step, event) =>
    @editing true
    setTimeout ()=>
      $(event.target).parent().find('input').focus()
    ,100

  stopEditing: =>
    $.ajax(type: 'PUT', url: "/steps/#{@id}.json", data: {step: {name: @name}})
      .fail (error) =>
        bootbox.alert(error.responseText)
    @editing false

class WorkItem
  constructor: (params) ->
    @id = params['id']
    @name = params['name']
    @description = params['description']
    @position = params['position']
    @assigned_to = params['assigned_to']
    @step_id = params['step_id']

class ProjectViewModel
  constructor: ->
    @stepNameField = $('#stepName')
    @steps = ko.observableArray []
    @account_id = ACCOUNT_ID
    @project_id = PROJECT_ID
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

  addNewStep: =>
    stepName = @stepNameField.val()
    #save the new project step
    $.ajax(type: 'POST', url: "/accounts/#{@account_id}/projects/#{@project_id}/steps.json", data: {step: {name: stepName}})
      .done (resp) =>
        @steps.push new Step({id: resp.id, name: resp.name, position: resp.position, removable: resp.removable, capacity: resp.capacity})
      .fail (error) =>
        bootbox.alert(error.responseText)
    @stepNameField.val('')

  selectWorkItem: (item) =>
    console.log item

  showSteps: ()=>
    $.getJSON "/accounts/#{@account_id}/projects/#{@project_id}/steps.json", (steps) =>
      $.map steps, (step) =>
          workItems = []
          $.map step.work_items, (w_i) =>
            workItems.push new WorkItem id: w_i.id, name: w_i.name, description: w_i.description, position: w_i.position, assigned_to: w_i.assigned_to, step_id: step.id
          @steps.push new Step id: step.id, name: step.name, position: step.position, removable: step.removable, capacity: step.capacity, work_items: workItems

  deleteStep: (currentStep)=>
    $.ajax(type: 'DELETE', url: "/steps/#{currentStep.id}.json")
      .done (resp) =>
        @steps.remove(currentStep)
        @updateStepsPositionsOnServer()
        bootbox.alert("Step #{currentStep.name} successfully deleted.")
      .fail (error) =>
        bootbox.alert(error.responseText)

  updateStepsPositionsOnServer: =>
    new_positions = ({id: n.id, position: index} for n, index in @steps())
    $.ajax(type: 'POST', url: "/steps/update_positions.json", data: {steps: new_positions})

  editStep: =>
    console.log 'Edit'

$ ->
  ko.applyBindings new ProjectViewModel()
