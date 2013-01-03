class WorkTypesController < ApplicationController
  # GET /work_types
  # GET /work_types.json
  def index
    @work_types = WorkType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @work_types }
    end
  end

  # GET /work_types/1
  # GET /work_types/1.json
  def show
    @work_type = WorkType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @work_type }
    end
  end

  # GET /work_types/new
  # GET /work_types/new.json
  def new
    @work_type = WorkType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @work_type }
    end
  end

  # GET /work_types/1/edit
  def edit
    @work_type = WorkType.find(params[:id])
  end

  # POST /work_types
  # POST /work_types.json
  def create
    @work_type = WorkType.new(params[:work_type])

    respond_to do |format|
      if @work_type.save
        format.html { redirect_to @work_type, notice: 'Work type was successfully created.' }
        format.json { render json: @work_type, status: :created, location: @work_type }
      else
        format.html { render action: "new" }
        format.json { render json: @work_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /work_types/1
  # PUT /work_types/1.json
  def update
    @work_type = WorkType.find(params[:id])

    respond_to do |format|
      if @work_type.update_attributes(params[:work_type])
        format.html { redirect_to @work_type, notice: 'Work type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @work_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_types/1
  # DELETE /work_types/1.json
  def destroy
    @work_type = WorkType.find(params[:id])
    @work_type.destroy

    respond_to do |format|
      format.html { redirect_to work_types_url }
      format.json { head :no_content }
    end
  end
end
