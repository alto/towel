module ActiveRecordMatchers
  
  class HaveValidAssociations
    def matches?(model)
      @failed_association = nil
      @model_class = model.class
      
      model.class.reflect_on_all_associations.each do |assoc|
        model.send(assoc.name, true) rescue @failed_association = assoc.name
      end
      !@failed_association
    end
  
    def failure_message
      "invalid association \"#{@failed_association}\" on #{@model_class}"
    end
  end
  def have_valid_associations
    HaveValidAssociations.new
  end
  
  class HaveValidatedPresenceOf
    def initialize(field, options={})
      @field=field
      @options = options
    end
    
    def matches?(model)
      @model=model.new
      if @options[:if]
        @options[:if].keys.each do |key|
          @model.send("#{key.to_s}=".to_sym, @options[:if][key])
        end
      end
      if defined?(GetText)
        locale = GetText.locale
        GetText.set_locale('en')

        @model.valid?  
        
        GetText.set_locale(locale)
      else
        @model.valid?  
      end
      
      return false unless field_errors = @model.errors.on(@field)
      field_errors.each do |e| 
        return true if e =~ /can't be blank/
        return true if e =~ /kann nicht leer sein/
      end
      false
    end
    
    def description
      "have validate_presence_of #{@field}"
    end
    
    def failure_message
      "expected to validate_presence_of #{@field} but doesn't"
    end

    def negative_failure_message
      "not expected to validate_presence_of #{@field} but does"
    end
  end
  def have_validated_presence_of(field, options={})
    HaveValidatedPresenceOf.new(field, options)
  end

  class ProtectAttribute
    def initialize(field, options={})
      @field=field
      @options = options
    end
    
    def matches?(model)
      @model=model.new(@field.to_sym => 'value')
      @model.send(@field) == 'value' ? false : true
    end
    
    def description
      "protect the record field #{@field}"
    end
    
    def failure_message
      "expected to protect the attribute #{@field}, but it doesn't"
    end

    def negative_failure_message
      "not expected to protect the attribute #{@field}, but it does"
    end
  end
  def protect_attribute(field, options={})
    ProtectAttribute.new(field, options)
  end

  class HaveValidatedAsAttachment
    def matches?(model)
      @model=model.new
      if defined?(GetText)
        locale = GetText.locale
        GetText.set_locale('en')

        @model.valid?  
        
        GetText.set_locale(locale)
      else
        @model.valid?  
      end

      [:content_type, :size, :filename].each do |field|
        return false unless field_errors = @model.errors.on(field)
        match = false
        field_errors.each do |e| 
          match = true if e =~ /can't be blank/
          match = true if e =~ /kann nicht leer sein/
        end
        return false unless match
      end
      [:size].each do |field|
        return false unless field_errors = @model.errors.on(field)
        match = false
        field_errors.each do |e| 
          match = true if e =~ /is not included in the list/
          match = true if e =~ /ist nicht in der Liste enthalten/
        end
        return false unless match
      end
      true
    end
    
    def description
      "have validates_as_attachment"
    end
    
    def failure_message
      "expected to validates_as_attachment but doesn't"
    end
  end
  def have_validated_as_attachment
    HaveValidatedAsAttachment.new
  end

end
