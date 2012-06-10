require 'spec_helper'

# here we keep the spec for tags

describe Sculpture do
    before do
        Sculpt.pretty = false # makes it less fiddly for testing tags.
    end
    
    it "should create simple <br> tags" do
        makes "<br>" do
            br
        end
    end
    
    it "should handle a custom anchor constructor" do
        makes "<a href=\"url\">text</a>" do
            a "text", "url"
        end
    end
    
    it "should handle a custom img constructor" do
        makes "<img src=\"my_lolcat.jpg\">" do
            img "my_lolcat.jpg"
        end
    end
    
    it "should override the kernel for paragraphs" do
        makes "<p>chunky bacon</p>" do
            p "chunky bacon"
        end
    end
    
    it "should handle js files as arguments" do
        gen = "<script type=\"text/javascript\" src=\""
        str = gen+"chunky\"></script>" + gen+"bacon\"></script>"
        makes str do
            js "chunky", "bacon"
        end
    end
    
    it "should turn an array into an unordered list" do
        makes "<ul><li>very</li><li>chunky</li><li>bacon</li></ul>" do
            ul ["very","chunky","bacon"]
        end
    end
    
    it "should turn an array into an ordered list" do
        makes "<ol><li>ein</li><li>zwei</li><li>drei</li></ol>" do
            ol ["ein","zwei","drei"]
        end
    end
    
    it "should set attributes from a hash before a block" do
        makes "<div id=\"ducks\"><span>quack</span></div>" do
            div id: :ducks do
                span "quack"
            end
        end
    end
    
    it "should set attributes from a hash after a method" do
        makes "<div class=\"classy\">an amusing test case</div>" do
            div "an amusing test case", class: :classy
        end
    end 
    
    it "should accept _s methods to create strings" do
        makes "<span>an unexpected <a href=\"url\">link</a></span>" do
            span do
                puts "an unexpected " + a_s("link","url")
            end
        end
    end
    
    it "should unindent multi-line statics" do
        makes "multi-line\nstatic" do
            puts "
            multi-line
            static"
        end
    end
    
    it "should unindent multi-line paragraphs" do
        makes "<p>multi-line\nparagraph</p>" do
            p "
            multi-line
            paragraph"
        end
    end
end