#= require ./projects/project

class Project extends ko.Model
  @persistAt 'project' # This is enough to save the model RESTfully to `/projects/{id}` URL
  @fields 'id', 'slug', 'name', 'description' # This is optional and will be inferred if not used

myViewModel: ->
