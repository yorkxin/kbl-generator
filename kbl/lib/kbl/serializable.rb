require 'haml'

module KBL::Serializable
  def self.included(base)
    base.send :extend, ClassMethods
  end

  def to_xml
    self.class.template.render(self)
  end

  module ClassMethods
    def template
      @template ||= load_template
    end

    def load_template
      filename = File.expand_path("templates/#{template_name}.haml", File.dirname(__FILE__))
      template = Haml::Engine.new(File.read(filename))
    end

    def template_name
      self.to_s.downcase.split("::").last
    end
  end
end
