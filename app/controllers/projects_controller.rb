class ProjectsController < ApplicationController

	before_filter :authenticate_user!

  def index
    if params[:account_id]
      @projects = Project.where('account_id = ?', params[:account_id])
    else
      @projects = Project.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  def show
    @project = Project.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    Project.transaction do
      @project = Project.new(params[:project])
      backlog = Step.new({name: 'Backlog', removable: false, position: 0})
      selected = Step.new({name: 'To Do', removable: true, position: 1})
      archive = Step.new({name: 'Archive', removable: false, position: 2, capacity: 0})
      @project.steps = [backlog, selected, archive]

      respond_to do |format|
        if @project.save
          current_user.memberships.create role: Role.find_by_name("owner"), project: @project
          format.html { redirect_to @project, notice: 'Project was successfully created.' }
          format.json do
            render json: @project, status: :created
         end
        else
          format.html { render action: "new" }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end
end
