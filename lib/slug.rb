# Used to generate slug(permalink) field from a specified column
module Slug
  def self.included(base)
    base.extend Slug::ClassMethods
  end

  module ClassMethods

    # Redefines the setter method of the specified field to generate also the slug field.
    # Slug is generated removing witespace and downcasing all characters adding the timestamp at the end.
    # Ex: "Gigel has 4 apples" => "gigelhas4apples_1357720078"
    # * *Args*    :
    #   - +name+ -> the name of the field to generate slug from
    def slug_for_name name = :name
      # include Slug::InstanceMethods

      define_method "#{name.to_s}=" do |value|
        self.send("#{name.to_s}_will_change!")
        write_attribute name, value
        if self.send("#{name.to_s}_changed?") && !self.slug
          self.slug = value.gsub(/[\s]/,'').gsub(/[\W]/,'').downcase << '_' << Time.now.to_i.to_s unless value.nil?
          count_slugs = self.class.count(:conditions => ["slug like ?", "#{self.slug}%"])
          if ( count_slugs > 0)
            self.slug = "#{self.slug}-#{count_slugs}"
          end
        end
      end
    end
    alias :slug_for_field :slug_for_name
  end

  # module InstanceMethods
  #   def to_param
  #     slug
  #   end
  # end

end
