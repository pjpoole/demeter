require 'singleton'

module Introspection
  class Introspected
    include Singleton

    attr_accessor :tree

    def initialize
      @tree = {}

      build_class_tree
    end

    def object_tree(type)
      object_enumerator(type).each do |obj|
        find_object(obj) unless obj.name.nil?
      end
    end

    def build_class_tree
      [::Module, ::Class].each do |item|
        object_tree(item)
      end
    end

    def add_objects_to_tree
      [::Module, ::Class].each do |item|
        object_enumerator(item).each do |obj|
          next if obj.name.nil?

          scope = find_object(obj)

          scope[:_mod] = case obj
          when ::Module
            Introspection::Module.new(obj)
          when ::Class
            Introspection::Class.new(obj)
          end
        end
      end

      @tree
    end

    def object_enumerator(type)
      ObjectSpace.each_object(type)
    end

    def find_object(obj)
      scope = @tree

      obj.name.split("::").each do |name|
        sym = name.to_sym
        scope[sym] ||= {}
        scope = scope[sym]
      end

      scope
    end
  end

  class Object
    def initialize(obj)
      @id     = obj.object_id
      # @obj    = obj
    end

  end

  class Module < Introspection::Object
    attr_reader :name

    def initialize(mod)
      @name       = mod.name.split("::").last
      @meths      = mod.instance_methods(false)
      @ancestors  = mod.ancestors.tap { |x| x.delete(mod) }.map { |m| m.name }
      super(mod)
    end

    def inspect
      @name
    end
  end

  class Class < Introspection::Module
    def initialize(klass)
      @superklass = klass.superclass
      super(klass)
    end
  end
end

tree = Introspection::Introspection.instance
tree.add_objects_to_tree


f = File.new("objects.yml", "w")
f.write(YAML.dump(tree.tree))
f.close
