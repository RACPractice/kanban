class StepsController < ApplicationController

	before_filter :authenticate_user!
  respond_to :html, :json, :xml

  # GET /steps
  # GET /steps.json
  def index
    if params[:project_id]
      @steps = Step.joins(:projects).includes(:work_items, :work_items => :users, :work_items => :tasks).where('projects.id = ?', params[:project_id]).order('position ASC')
      steps = @steps.collect do |s|
        s.work_items.sort!{|a, b| a.position <=> b.position}
        s
      end
      @steps = steps
    else
      @steps = Step.all
    end

    respond_with @steps
  end

  # GET /steps/1
  # GET /steps/1.json
  def show
    @step = Step.find_by_slug(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @step }
    end
  end

  # GET /steps/new
  # GET /steps/new.json
  def new
    @step = Step.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @step }
    end
  end

  # GET /steps/1/edit
  def edit
    @step = Step.find_by_slug(params[:id])
  end

  # POST /steps
  # POST /steps.json
  def create
    @project = Project.find(params[:project_id])
    position = Step.joins(:projects).where('projects.id = ?', @project.id).maximum('steps.position')
    position = 1 unless position
    @step = @project.steps.create(params[:step])
    @step.position = position - 1
    respond_to do |format|
      if @step.save
        ProjectMailer.notify_step_created(@step, current_user).deliver
        format.html { redirect_to @step, notice: 'Step was successfully created.' }
        format.json do
          render json: @step, status: :created
        end
      else
        format.html { render action: "new" }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /steps/1
  # PUT /steps/1.json
  def update
    @step = Step.find(params[:id])
    respond_to do |format|
      if @step.update_attributes(params[:step])
        format.html { redirect_to @step, notice: 'Step was successfully updated.' }
        format.json { render :json => {:message => "Success"} }
      else
        format.html { render action: "edit" }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /steps/1
  # DELETE /steps/1.json
  def destroy
    @step = Step.find(params[:id])
    if @step.removable
      step_name = @step.name
      project = @step.projects.first
      @step.destroy

      ProjectMailer.notify_step_deleted(step_name, project, current_user).deliver
      respond_to do |format|
        format.html { redirect_to steps_url }
        format.json { render :json => {:message => "Success"} }
      end
    else
      respond_to do |format|
        format.html { redirect_to steps_url }
        format.json { render :json => "Step #{@step.name} is not removable", :status => :unprocessable_entity}
      end
    end
  end

  def update_positions
    if params['steps']
      params['steps'].each do |k, item|
        Step.update_all({:position => item['position']}, ['id = ?', item['id']])
      end
    end
    render :json => {:message => "Success"}
  end
end
