require 'spec_helper'

# this spec is for testing generic sculpt features
# for tag specs see sculpture_spec

describe Sculpt do
    context "with pretty print enabled" do
        before do
            Sculpt.pretty = true
        end
        
        stdres = "<!DOCTYPE html>\n<html>\n<p>test</p>\n</html>"
        
        it "should create a bare bones HTML doc from a block" do
            Sculpt.make_doc do
                p "test"
            end.should eq stdres
        end
        
        it "should create a bare bones HTML doc from a string of code" do
            Sculpt.make_doc('p "test"').should eq stdres
        end
    end
    
    context "without pretty print enabled" do
        before do
            Sculpt.pretty = false
        end
        
        stdres = "<!DOCTYPE html><html><p>test</p></html>"
        
        it "should create a bare bones doc" do
            Sculpt.make_doc do
                p "test"
            end.should eq stdres
        end
        
        it "should create a bare bones doc from a string of code" do
            Sculpt.make_doc('p "test"').should eq stdres
        end
    end
    
    context "with smart attrs disabled" do
        before do
            Sculpt.smart_attrs = false
        end
        
        it "should not replace symbols with underscores with dashes" do
            Sculpt.make do
                p "This paragraph", data_is: :notsome
            end.should eq "<p data_is=\"notsome\">This paragraph</p>"
        end
    end
    
    context "with smart attrs enabled" do
        before do
            Sculpt.smart_attrs = true
        end
        
        it "should replace symbols with underscores with dashes" do
            Sculpt.make do
                p "This paragraph", data_is: :awesome
            end.should eq "<p data-is=\"awesome\">This paragraph</p>"
        end
        
        it "should not replace underscores in values, just keys" do
            Sculpt.make do
                p "Quack", data_said_by: :a_duck
            end.should eq "<p data-said-by=\"a_duck\">Quack</p>"
        end
        it 'should take nested hashes for the data element and be able to parse it properly' do
            Sculpt.make do
                div 'some stuff', data: { name: 'first last', email: 'some@email.com' }
            end.should eq "<div data-name=\"first last\" data-email=\"some@email.com\">some stuff</div>"
        end
    end
end