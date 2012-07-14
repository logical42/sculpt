class Tag < ElementContainer
    include SculptHelpers
    
    attr_accessor :name, :text, :attrs, :singelton, :inline
    
    def initialize(name, text = '', attrs = {}, &block)
        @name = name
        @attrs = {}
        @elements = []
        @inline = false
        @text = ''
        
        set_up(text, attrs, &block)
    end
    
    def set_up(text = '', attrs = {}, &block)
        # this method can be called from either the class hack or the init.
        if text.is_a? Tag
            @inline = text
            @elements << text
            @attrs.merge!(attrs) if attrs.is_a? Hash
            return self
        elsif text.is_a? Hash
            @attrs.merge!(text)
        elsif text.is_a? String
            @text = text
        end
        
        @attrs.merge!(attrs) if attrs.is_a? Hash
        
        if block_given?
            @elements += elements_from_block(&block)
        end
        @singleton = is_singleton? @name
        
        self # needed for funky classes
    end
    
    def generate_html(ugly = false)
        pp = Sculpt.pretty and not ugly  
           
        n = @name.to_s
        open = apply_attributes(@attrs, "<#{n}")
        open << '>'
        return open if @singleton
        close = "</#{n}>"
        return open + @text + close unless @elements.any?
        html = ''
        @elements.each do |element|
            html += element.generate_html
            html += "\n" if pp unless inline or element.is_a? Static
        end
        return "#{open}\n#{html}#{close}" if pp and not inline
        return open + html + close
    end
    
    def method_missing(m, *args, &block)
        # this is the class hack.
        # it's quite cool.
        # it basically let's you call tag.class and have class be set as the class for tag.
        # it requires a bit of extra work elsewhere (as arguments get passed to this method instead).
        @attrs[:class] = "" unless @attrs[:class]
        @attrs[:class] += " " unless @attrs[:class].empty?
        @attrs[:class] += m.to_s
        case @name
        when :a
            attrs = special_attr(:href, args[1], args[2])
            set_up(args[0], attrs, &block)
        when :img
            attrs = special_attr(:src, args[0], args[1])
            set_up(attrs)
        when :ul,:ol
            t = args[0]
            if t.is_an? Array or t.is_af? Range
                t.each do |item|
                    @elements << Tag.new(:li,item)
                end
                set_up('',args[1])
            else
                set_up(args[0],args[1], &block)
            end
        else
            set_up(args[0], args[1], &block)
        end
    end
    private
    def apply_attributes(attributes, open_tag_content)
        attributes.each do |key, value| 
            if value.is_a?(Hash)
                ## accept nested hashes like content_tag Rails 
                ## ex. div 'some div content', data: {attr1: 'value of data-attr1', attr2: 'value of data-attr2'}
                ## -> <div data-attr1='value of data-attr1' data-attr2='value of data-attr2'>some div content</div>

                value.each do |nested_key, nested_value| 
                    open_tag_content << " #{key}-#{nested_key}=\"#{nested_value}\"" 
                end
            else
                open_tag_content << " #{attr_replace(key)}=\"#{value}\""
            end
        end
        return open_tag_content
    end
end

class Static
    attr_accessor :string
    
    def initialize(string)
        @string = string
    end
    
    def generate_html
        return @string+"\n" if Sculpt.pretty?
        @string
    end
end