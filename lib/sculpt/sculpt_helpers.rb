module SculptHelpers
    def elements_from_block(&block)
        result = Sculpture.new
        result.instance_eval(&block)
        result.elements
    end
    
    def is_singleton? tag
        [:area, :base, :br, :col, :command, :embed, :hr, :img, :input, :link, :meta, :param, :source].include? tag
    end
    
    def special_attr(att, val, extra)
        attrs = {att => val}
        return attrs.merge(extra) if extra.is_a? Hash
        attrs
    end
    
    def attr_replace(a)
        if a.is_a? Symbol and Sculpt.smart_attrs?
            return a.to_s.gsub('_','-')
        end
        a
    end
end

# general core extensions below

class String
    # this one from mynyml/unindent on github
    def unindent
        indent = self.split("\n").select {|line| !line.strip.empty? }.map {|line| line.index(/[^\s]/) }.compact.min || 0
        self.gsub(/^[[:blank:]]{#{indent}}/, '')
    end
    def unindent!
        self.replace(self.unindent)
    end
    
    # this one by me
    def to_proc
        eval "Proc.new do\n#{self}\nend"
    end
end

class Object
    def is_an?(type) # my type checks *will* have correct grammar
        is_a?(type)
    end
end