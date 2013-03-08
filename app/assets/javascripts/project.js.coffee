class Step
  constructor: (params) ->
    @id = params['id']
    @name = ko.observable params['name']
    @position = params['position']
    @removable = params['removable']
    @capacity = ko.observable params['capacity']
    @category = params['category']
    @work_items = ko.observableArray params['work_items'] || []
    @users = ko.observableArray []
    @editing = ko.observable false
    @editingCapacity = ko.observable false
    @work_item_textarea = ko.observable ''
    @addWorkItemVisible = ko.observable false
    @collapsed = ko.observable false

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
      cls = ''
      cls = cls + ' collapsed ' if @collapsed()
      if @removable
        cls = cls + ' is_sortable '
      else
        cls = cls + ' not_sortable '

      current_capacity = _.reduce @work_items(), ((sum, wi) => sum + parseInt(wi.work_value())), 0
      cls = cls + 'exceeded' if current_capacity > 0 && @capacity() > 0 && current_capacity >= @capacity()
      cls

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

class Task
  constructor: (params) ->
    @id = params['id']
    @name = ko.observable params['name']
    @done = ko.observable(params['done'] || false)
    @blocked = ko.observable(params['blocked'] || false)
    @work_item_id = params['work_item_id']
    @editMode = ko.observable false

    @done.subscribe =>
      @save()
    @name.subscribe =>
      @save()
    @blocked.subscribe =>
      @save()

    @task_class = ko.computed =>
      css_class = ''
      if ko.utils.unwrapObservable(@done) == true
        css_class = 'done'
      else if ko.utils.unwrapObservable(@blocked) == true
        css_class = 'blocked'
      css_class

  toggleEditMode: =>
    @editMode !@editMode()

  blockTask: =>
    @blocked true
    @done false
    @editMode false

  unblockTask: =>
    @blocked false
    @editMode false

  save: =>
    if @id
      $.ajax type: 'PUT', url: SETTINGS.tasks.update_path(@id), data:
        task:
          id: @id
          ,name: @name
          ,done: @done
          ,blocked: @blocked
    else
      $.ajax type: 'POST', url: SETTINGS.tasks.create_path, data:
        task:
          name: @name
          ,done: @done
          ,blocked: @blocked
          ,work_item_id: @work_item_id

  delete: =>
    $.ajax type: 'DELETE', url: SETTINGS.tasks.delete_path(@id)

class WorkItem
  constructor: (params) ->
    @id = params['id']
    @name = ko.observable params['name']
    @description = ko.observable params['description']
    @position = params['position']
    @assigned_to = params['assigned_to']
    @step_id = params['step_id']
    @work_value = ko.observable params['work_value']
    @memberships = ko.observableArray params['memberships'] || []
    @tasks = ko.observableArray params['tasks'] || []
    @labels = ko.observableArray params['label_list'] || []
    @label_list = ko.observable ko.utils.unwrapObservable(@labels).join(', ')
    @new_task_name = ko.observable ''

    @new_task_name.subscribe (value) =>
      return if value.length == 0
      task = new Task id: null, name: value, work_item_id: @id
      task.save()
      @tasks.push task
      @new_task_name ''

    # @tasks.subscribe (param) =>
    #   @save()
    @memberships.subscribe (param) =>
      @save()
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

  droped: (membership) =>
    existing = _.find @memberships(), (m) => m.user_id == membership.user_id
    @memberships.push membership unless existing

  removeTask: (task) =>
    task.delete()
    @tasks.remove(task)

  save: =>
    $.ajax type: 'PUT', url: SETTINGS.work_items.update_path(@id), data:
      work_item:
        users: _.map(@memberships(), (e) => e.user_id)
        ,id: @id
        ,name: @name
        ,description: @description
        ,work_value: @work_value
        ,label_list: @label_list

class Membership
  constructor: (params) ->
    @id        = params['id']
    @user_id   = params['user_id']
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

    @steps.subscribe (param1) =>
      #

    @custom_steps = ko.computed ()=>
      ko.utils.arrayFilter @steps(), (item) =>
        item.removable == true

    @steps.subscribe () =>
      @updateStepsPositionsOnServer()
    ,@
    ,'positionsChanged'

    @showSteps()
    @loadMemberships()


  addNewStep: =>
    stepName = @newStepInput()
    #save the new project step
    $.ajax(type: 'POST', url: SETTINGS.steps.steps_path, data: {step: {name: stepName}})
      .done (resp) =>
        step = new Step({id: resp.id, name: resp.name, position: resp.position, removable: resp.removable, category: resp.capacity, capacity: resp.capacity})
        @steps.splice(@steps().length - 1, 0, step);
        @updateCols()
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
      _steps = @steps()
      $.map steps, (step) =>
          workItems = []
          $.map step.work_items, (w_i) =>
            memberships = []
            $.map w_i.users, (m) =>
              memberships.push new Membership id: m.id, user_id: m.user_id, username: m.username, role_name: m.role_name, avatar_src: m.avatar_src
            tasks = []
            $.map w_i.tasks, (t) =>
              tasks.push new Task id: t.id, name: t.name, done: t.done, work_item_id: t.work_item_id, blocked: t.blocked
            workItems.push new WorkItem id: w_i.id, name: w_i.name, description: w_i.description, position: w_i.position, assigned_to: w_i.assigned_to, step_id: step.id, work_value: w_i.work_value, memberships: memberships, label_list: w_i.label_list, tasks: tasks
          step = new Step id: step.id, name: step.name, position: step.position, removable: step.removable, capacity: step.capacity, category: step.category, work_items: workItems, subscribers: {positionsChanged: @updateCols}
          if !step.removable
            @backlog_step(step) if step.category == 'backlog'
            @archive_step(step) if step.category == 'archive'
          _steps.push step
      @steps.notifySubscribers()
      @updateCols()

  loadMemberships: =>
    $.getJSON SETTINGS.memberships.memberships_path, (resp) =>
      $.map resp.memberships, (m) =>
        membership = new Membership id: m.id, user_id: m.user_id, username: m.username, role_name: m.role_name, avatar_src: m.avatar_src
        @memberships.push m
      ko.utils.arrayPushAll(@non_members, resp.non_members)
      $('#userName').autocomplete(source: @non_members)

  deleteStep: (currentStep)=>
    $.ajax(type: 'DELETE', url: SETTINGS.steps.update_path(currentStep.id))
      .done (resp) =>
        @steps.remove(currentStep)
        @updateStepsPositionsOnServer()
        @updateCols()
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
    $('#editWorkItemPopup').modal
      keyboard: true
    $('.rating').buttonset()
    $('.taggable').select2
      tags:[]
      ,tokenSeparators: [","]

  updateWorkItem: =>
    $('#editWorkItemPopup').modal 'hide'
    wi = @editingWorkItem()
    wi.save()

  toggleStep: (step)=>
    step.collapsed !step.collapsed()
    @updateCols()

  updateCols: =>
    col_wrapper = $("ul.steps")
    cols = $("ul.steps .col")
    cols_c = cols.filter(".collapsed")

    col_w = (col_wrapper.width() - 1 - (cols.length * 4) - (cols_c.length * 40)) / (cols.length - cols_c.length)
    cols.width(40)
    cols.not(".collapsed").css({width: col_w + "px"})
    console.log 'recalculate width'

$ ->
  model  = new ProjectViewModel()
  ko.applyBindings model
  $(window).resize =>
    model.updateCols()
  $('#editWorkItemPopup').on 'keydown', '.no_submit', (event)=>
    if event.keyCode == 13
      $(event.target).trigger 'change'
      event.preventDefault()
      return false
