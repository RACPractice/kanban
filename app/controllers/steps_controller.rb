class StepsController < ApplicationController

	before_filter :authenticate_user!

  # GET /steps
  # GET /steps.json
  def index
    if params[:project_id]
      @steps = Step.joins(:projects).includes(:work_items).where('projects.id = ?', params[:project_id])
      steps = @steps.collect do |s|
        s.work_items.sort!{|a, b| a.position <=> b.position}
        s
      end
      @steps = steps
    else
      @steps = Step.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json {render json: @steps.to_json(:include => :work_items) }
    end
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
    @step = @project.steps.create(params[:step])

    respond_to do |format|
      if @step.save
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
    @step = Step.find_by_slug(params[:id])

    respond_to do |format|
      if @step.update_attributes(params[:step])
        format.html { redirect_to @step, notice: 'Step was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /steps/1
  # DELETE /steps/1.json
  def destroy
    @step = Step.find_by_slug(params[:id])
    @step.destroy

    respond_to do |format|
      format.html { redirect_to steps_url }
      format.json { head :no_content }
    end
  end
end
