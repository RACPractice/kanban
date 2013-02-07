class UpdateCategoryForExistingSteps < ActiveRecord::Migration
  def up
  	Step.all.each do |step|
  		case step.name
  		when 'Backlog'
  			step.category = 'backlog'
  		when 'Archive'
  			step.category = 'archive'
      else
        step.category = 'custom'
  		end

      step.save
  	end
  end

  def down
  end
end
