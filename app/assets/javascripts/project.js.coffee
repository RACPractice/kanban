class Step
  constructor: (params) ->
    @id = params['id']
    @name = params['name']
    @position = params['position']
    @removable = params['removable']
    @capacity = params['capacity']
    @work_items = ko.observableArray params['work_items']

    @work_items.subscribe (param1) =>
      console.log "Work Items have been reordered. Send to server"
    ,@
    ,'itemAdded'

  addWorkItem: =>
    workItemName = $('.work-item-name-for-step-' + @id).val()
    $.ajax(type: 'POST', url: "/work_items.json", data: {work_item: {name: workItemName, step_id: @id}})
      .done (resp) =>
        @work_items.push new WorkItem({id: resp.id, name: resp.name, description: resp.description, position: resp.position, step_id: resp.step_id, assigned_to: resp.assigned_to})
      .fail (error) =>
        alert error.responseText
    @closeForm()

  showWorkItemForm: =>
    $('.work-item-for-step-' + @id).show()
  closeForm: =>
    $('.work-item-name-for-step-' + @id).val('')
    $('.work-item-for-step-' + @id).hide()


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
    @showSteps()

  addNewStep: =>
    stepName = @stepNameField.val()
    #save the new project step
    $.ajax(type: 'POST', url: "/accounts/#{@account_id}/projects/#{@project_id}/steps.json", data: {step: {name: stepName, project_id: @project_id}})
      .done (resp) =>
        @steps.push new Step(resp.id, resp.name, resp.project_id)
      .fail (error) =>
        alert error.responseText
    @stepNameField.val('')

  editStep: (step) =>
    step.name = @stepNameField.val()


  selectWorkItem: (item) =>
    console.log item

  showSteps: ()=>
    $.getJSON "/accounts/#{@account_id}/projects/#{@project_id}/steps.json", (steps) =>
      $.map steps, (step) =>
          workItems = []
          $.map step.work_items, (w_i) =>
            workItems.push new WorkItem id: w_i.id, name: w_i.name, description: w_i.description, position: w_i.position, assigned_to: w_i.assigned_to, step_id: step.id
          @steps.push new Step id: step.id, name: step.name, position: step.position, removable: step.removable, capacity: step.capacity, work_items: workItems


$ ->
  ko.applyBindings new ProjectViewModel()

