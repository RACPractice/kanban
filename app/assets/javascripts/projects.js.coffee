class Project
  constructor: (@id, @slug, @name, @account_id) ->
    @project_url = "projects/#{@id}"

class ProjectsViewModel
  constructor: ->
    @projectNameField = $('#projectName')
    @projectSlugField =$('#projectSlug')
    @projectIdField =$('#projectId')
    @projects = ko.observableArray []
    @account_id = ACCOUNT_ID
    @project_id = PROJECT_ID
    @listProjects()

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

  listProjects: =>
    $.getJSON "/accounts/#{@account_id}/projects", (acc) =>
      $.map acc, (item) =>
        @projects.push new Project(item.id, item.slug, item.name)

$ ->
  ko.applyBindings new ProjectsViewModel()
