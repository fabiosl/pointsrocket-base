class Service

  def initialize resource
    @resource = resource
  end

  def self.new_item new_params={}, options={}
    resource_class.new new_params
  end

  def self.index options
    resource_class.all
  end

  def self.find id, options={}
    resource_class.find id
  end

  def self.destroy id, options
    find(id, options).destroy
  end

  def self.create create_params, options={}
    item = new_item(create_params, options)
    item.save
    item
  end

  def self.update id, update_params, options
    find(id, options).update(update_params)
  end

  private

    def self.resource_class
      self.resource_name.classify.constantize
    end

    def self.resource_name
      @resource_name ||= self.name.chomp("Service")
    end

    def self.resource_name_plural
      @resource_name_plural ||= resource_name.pluralize.downcase
    end

end
