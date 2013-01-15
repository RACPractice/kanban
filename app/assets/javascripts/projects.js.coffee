class Project
  constructor: (@id, @slug, @name, @account_id) ->
    @project_url = "projects/#{@id}"

class Step
  constructor: (@id, @name) ->

class ProjectsViewModel
  constructor: ->
    @projectNameField = $('#projectName')
    @projectSlugField =$('#projectSlug')
    @projectIdField =$('#projectId')
    @projects = ko.observableArray []
    @steps = ko.observableArray []
    @account_id = ACCOUNT_ID
    @project_id = PROJECT_ID
    @showProject()

  addNewProject: =>
    projectName = @projectNameField.val()
    #save the new project
    $.ajax(type: 'POST', url: "/accounts/#{@account_id}/projects.json", data: {project: {name: projectName, account_id: @account_id}})
    .done (resp) =>
      @projects.push new Project(resp.id, resp.slug, resp.name, resp.account_id)
    .fail (error) =>
      alert error.responseText
    @projectNameField.val('')

  removeProject: (project) =>
    @projects.remove(project)

  editProject: (project) =>
    project.name = @projectNameField.val()

  showProject: =>
    $.getJSON "/accounts/#{@account_id}/projects/#{@project_id}/steps.json", (acc) =>
      $.map acc, (item) =>
        @steps.push new Step(item.id, item.name)

$ ->
  ko.applyBindings new ProjectsViewModel()
