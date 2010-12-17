module PivotalPlanningPoker
  class TrackerEntity
    attr_accessor :doc

    def self.tracker_attribute(name, xpath)
      raise ArgumentError, "Can't create an attribute over a method that exists #{self.name}##{name}!" if self.instance_methods.include?(name.to_s)
      
      class_eval <<-EOS
         def #{name}
          doc.xpath('#{xpath}').text
        end
      EOS
    end

    def initialize(doc)
      @doc = doc
    end
  end
end