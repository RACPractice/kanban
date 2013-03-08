class WorkItemsController < ApplicationController
  # GET /work_items
  # GET /work_items.json
  def index
    if params[:step_id].present?
      @work_items = WorkItem.find_by_step_id(params[:step_id])
    else
      @work_items = WorkItem.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @work_items }
    end
  end

  # GET /work_items/1
  # GET /work_items/1.json
  def show
    @work_item = WorkItem.find_by_slug(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @work_item }
    end
  end

  # GET /work_items/new
  # GET /work_items/new.json
  def new
    @work_item = WorkItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @work_item }
    end
  end

  # GET /work_items/1/edit
  def edit
    @work_item = WorkItem.find_by_slug(params[:id])
  end

  # POST /work_items
  # POST /work_items.json
  def create
    @work_item = WorkItem.new(params[:work_item])
    position = WorkItem.where('step_id = ?', @work_item.step_id).maximum('position') || -1
    @work_item.position = position + 1
    respond_to do |format|
      if @work_item.save
        format.html { redirect_to @work_item, notice: 'Work item was successfully created.' }
        format.json { render json: @work_item, status: :created, location: @work_item }
      else
        format.html { render action: "new" }
        format.json { render json: @work_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /work_items/1.json
  def update
    wi = WorkItem.find(params[:id])
    param_wi = params[:work_item]
    wi.assign_attributes(param_wi)
    if param_wi[:label_list] && param_wi[:label_list] != wi.label_list
      wi.label_list = param_wi[:label_list]
    end
    if param_wi[:users]
      param_wi[:users].each do |user_id|
        user_id_int = user_id.to_i
        unless (wi.users.find{|u| u.id == user_id_int})
          user = User.find(user_id_int)
          wi.users << user
          ProjectMailer.notify_work_item_assigned(wi, user).deliver
        end
      end
    end
    if param_wi[:tasks]
      new_tasks = param_wi[:tasks].find{|task| task.id == nil}
      existing_tasks_ids = param_wi[:tasks].reject{|task| task.id == nil}.collect{|x| x.id.to_i}
      tasks_ids = wi.tasks.map(&:id)
      puts "Existing: #{existing_tasks_ids.join(', ')}"
      puts "Database tasks: #{tasks_ids.join(', ')}"
    end

    if wi.save
      head :no_content
    else
      render json: @work_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /work_items/1
  # DELETE /work_items/1.json
  def destroy
    @work_item = WorkItem.find(params[:id])
    @work_item.destroy

    respond_to do |format|
      format.html { redirect_to work_items_url }
      format.json { head :no_content }
    end
  end

  def update_positions
    if params['work_items']
      params['work_items'].each do |k, item|
        work_item = WorkItem.find item['id']
        if work_item.step_id != item['step_id'].to_i
          if work_item.users.any?
            ProjectMailer.notify_step_changed_for_work_item(work_item, item['step_id'], current_user).deliver
          end
        end
        WorkItem.update_all({:position => item['position'], :step_id => item['step_id']}, ['id = ?', item['id']])
      end
    end
    render :text => "Success"
  end

  # def update_users
  #   wi = WorkItem.find params['work_item_id']
  #   params['users'].each do |user_id|
  #     user_id_int = user_id.to_i
  #     unless (wi.users.find{|u| u.id == user_id_int})
  #       user = User.find(user_id_int)
  #       wi.users << user
  #       ProjectMailer.notify_work_item_assigned(wi, user).deliver
  #     end
  #   end
  #   # format.json { head :no_content }
  #   render :text => "Success"
  # end
end
