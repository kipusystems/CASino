# require 'casino'
# require 'casino/inflections'
require 'yaml'

module Casino
  class Engine < Rails::Engine
    isolate_namespace Casino

    # config.autoload_paths += %W(
    # #{config.root}/app/processors/
    #   #{config.root}/app/processors/casino
    #   #{config.root}/app/helpers
    #   #{config.root}/app/models
    #   #{config.root}/app/models/casino
    #   #{config.root}/app/models/casino/model_concern
    #   #{config.root}/app/controllers/casino/controller_concern
    # )

    # config.eager_load_paths += %W(
    # #{config.root}/app/processors/
    #   #{config.root}/app/processors/casino
    #   #{config.root}/app/helpers
    #   #{config.root}/app/models
    #   #{config.root}/app/models/casino
    #   #{config.root}/app/models/casino/model_concern
    #   #{config.root}/app/controllers/casino/controller_concern
    # )

    rake_tasks { require 'casino/tasks' }

    initializer :yaml_configuration do |app|
      apply_yaml_config load_file('config/cas.yml')
    end

    private
    def apply_yaml_config(yaml)
      cfg = (YAML.load(ERB.new(yaml).result, aliases: true)||{}).fetch(Rails.env, {})
      cfg.each do |k,v|
        value = if v.is_a? Hash
          Casino.config.fetch(k.to_sym,{}).merge(v.symbolize_keys)
        else
          v
        end
        Casino.config.send("#{k}=", value)
      end
    end

    def load_file(filename)
      fullpath = File.join(Rails.root, filename)
      IO.read(fullpath) rescue ''
    end

  end
end
