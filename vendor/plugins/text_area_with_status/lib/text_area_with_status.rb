#
# = Purpose
#
# To extend text_area and text_area_tag methods with the capability to display
# remaining chars left to type
#

module TextAreaWithStatus

  DefaultMsg = "You have %d characters left."

  # The version of the method for InstanceTag
  module InstanceTagExt 
    def self.included(base) #:nodoc:
      base.alias_method_chain :to_text_area_tag, :status
    end

    # Extra options supported:
    #   
    #   :max_chars => Fixnum,
    #   :max_chars_msg => String
    #
    # In absence of :max_chars option, text_area will fall back to its
    # original, default behaviour
    def to_text_area_tag_with_status(options = {})
      if options[:max_chars]
        max_chars = options[:max_chars]
        msg = options[:max_chars_msg] || DefaultMsg
        options.delete_if {|k,v| k.to_s =~ /^max_chars/}

        span_id = "c_left_#{object.class.name.underscore}_#{@method_name}_#{object.id}"
        options[:onkeyup] = "limit_chars(this, #{max_chars}, $('#{span_id}'), '#{msg}')"
        span = "<br />\n<span id=\"#{span_id}\">#{msg}</span>" % (max_chars - (object.send(@method_name).length rescue 0))
      else
        span = ''
      end

      to_text_area_tag_without_status(options) + span
    end
  end

  # The version of the method for FormTagHelper
  module FormTagHelperExt
    def self.included(base) #:nodoc:#
      base.alias_method_chain :text_area_tag, :status
    end

    # Extra options supported:
    #   
    #   :max_chars => Fixnum,
    #   :max_chars_msg => String
    #
    # In absence of :max_chars option, text_area_tag will fall back to its
    # original, default behaviour
    def text_area_tag_with_status(name, content = nil, options = {})
      if options[:max_chars]
        max_chars = options[:max_chars]
        msg = options[:max_chars_msg] || DefaultMsg
        options.delete_if {|k,v| k.to_s =~ /^max_chars/}

        span_id = options[:id] ? "#{options[:id]}_left" : "c_#{name}_left"
        options[:onkeyup] = "limit_chars(this, #{max_chars}, $('#{span_id}'), '#{msg}')"
        span = "<br />\n<span id=\"#{span_id}\">#{msg}</span>" % (max_chars - (content ? content.length : 0))
      else
        span = ''
      end

      text_area_tag_without_status(name, content, options) + span
    end
  end

end
