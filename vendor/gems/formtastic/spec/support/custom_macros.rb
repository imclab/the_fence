module CustomMacros
  
  def self.included(base)
    base.extend(ClassMethods)    
  end
  
  module ClassMethods
    
    def it_should_have_input_wrapper_with_class(class_name)
      it "should have input wrapper with class '#{class_name}'" do
        output_buffer.concat(@form) if Formtastic::Util.rails3?
        output_buffer.should have_tag("form li.#{class_name}") 
      end
    end
    
    def it_should_have_input_wrapper_with_id(id_string)
      it "should have input wrapper with id '#{id_string}'" do
        output_buffer.concat(@form) if Formtastic::Util.rails3?
        output_buffer.should have_tag("form li##{id_string}") 
      end
    end
    
    def it_should_not_have_a_label
      it "should not have a label" do
        output_buffer.concat(@form) if Formtastic::Util.rails3?
        output_buffer.should_not have_tag("form li label") 
      end
    end
    
    def it_should_have_a_nested_fieldset
      it "should have a nested_fieldset" do
        output_buffer.concat(@form) if Formtastic::Util.rails3?
        output_buffer.should have_tag("form li fieldset") 
      end
    end
    
    def it_should_have_label_with_text(string_or_regex)
      it "should have a label with text '#{string_or_regex}'" do
        output_buffer.concat(@form) if Formtastic::Util.rails3?
        output_buffer.should have_tag("form li label", string_or_regex) 
      end
    end
    
    def it_should_have_label_for(element_id)
      it "should have a label for ##{element_id}" do
        output_buffer.concat(@form) if Formtastic::Util.rails3?
        output_buffer.should have_tag("form li label[@for='#{element_id}']")
      end
    end
    
    def it_should_have_input_with_id(element_id)
      it "should have an input with id '#{element_id}'" do
        output_buffer.concat(@form) if Formtastic::Util.rails3?
        output_buffer.should have_tag("form li input##{element_id}")
      end
    end
    
    def it_should_have_input_with_type(input_type)
      it "should have a #{input_type} input" do
        output_buffer.concat(@form) if Formtastic::Util.rails3?
        output_buffer.should have_tag("form li input[@type=\"#{input_type}\"]")
      end
    end
    
    def it_should_have_input_with_name(name)
      it "should have an input named #{name}" do
        output_buffer.concat(@form) if Formtastic::Util.rails3?
        output_buffer.should have_tag("form li input[@name=\"#{name}\"]")
      end
    end
    
    def it_should_have_textarea_with_name(name)
      it "should have an input named #{name}" do
        output_buffer.concat(@form) if Formtastic::Util.rails3?
        output_buffer.should have_tag("form li textarea[@name=\"#{name}\"]")
      end
    end
    
    def it_should_have_textarea_with_id(element_id)
      it "should have an input with id '#{element_id}'" do
        output_buffer.concat(@form) if Formtastic::Util.rails3?
        output_buffer.should have_tag("form li textarea##{element_id}")
      end
    end
    
    def it_should_use_default_text_field_size_when_method_has_no_database_column(as)
      it 'should use default_text_field_size when method has no database column' do
        @new_post.stub!(:column_for_attribute).and_return(nil) # Return a nil column
        
        form = semantic_form_for(@new_post) do |builder|
          concat(builder.input(:title, :as => as))
        end
        output_buffer.concat(form) if Formtastic::Util.rails3?
        output_buffer.should have_tag("form li input[@size='#{Formtastic::SemanticFormBuilder.default_text_field_size}']")
      end
    end
    
    def it_should_apply_custom_input_attributes_when_input_html_provided(as)
      it 'it should apply custom input attributes when input_html provided' do
        form = semantic_form_for(@new_post) do |builder|
          concat(builder.input(:title, :as => as, :input_html => { :class => 'myclass' }))
        end
        output_buffer.concat(form) if Formtastic::Util.rails3?
        output_buffer.should have_tag("form li input.myclass")
      end
    end
    
    def it_should_apply_custom_for_to_label_when_input_html_id_provided(as)
      it 'it should apply custom for to label when input_html :id provided' do
        form = semantic_form_for(@new_post) do |builder|
          concat(builder.input(:title, :as => as, :input_html => { :id => 'myid' }))
        end
        output_buffer.concat(form) if Formtastic::Util.rails3?
        output_buffer.should have_tag('form li label[@for="myid"]')
      end
    end
    
    def it_should_have_maxlength_matching_column_limit
      it 'should have a maxlength matching column limit' do
        @new_post.column_for_attribute(:title).limit.should == 50
        output_buffer.concat(@form) if Formtastic::Util.rails3?
        output_buffer.should have_tag("form li input[@maxlength='50']")
      end
    end
    
    def it_should_use_default_text_field_size_for_columns_longer_than_default_text_field_size(as)
      it 'should use default_text_field_size for columns longer than default_text_field_size' do
        default_size = Formtastic::SemanticFormBuilder.default_text_field_size
        @new_post.stub!(:column_for_attribute).and_return(mock('column', :type => as, :limit => default_size * 2))

        form = semantic_form_for(@new_post) do |builder|
          concat(builder.input(:title, :as => as))
        end

        output_buffer.concat(@form) if Formtastic::Util.rails3?
        output_buffer.should have_tag("form li input[@size='#{default_size}']")
      end
    end
    
    def it_should_use_column_size_for_columns_shorter_than_default_text_field_size(as)
      it 'should use the column size for columns shorter than default_text_field_size' do
        column_limit_shorted_than_default = 1
        @new_post.stub!(:column_for_attribute).and_return(mock('column', :type => as, :limit => column_limit_shorted_than_default))

        form = semantic_form_for(@new_post) do |builder|
          concat(builder.input(:title, :as => as))
        end

        output_buffer.concat(form) if Formtastic::Util.rails3?
        output_buffer.should have_tag("form li input[@size='#{column_limit_shorted_than_default}']")
      end
    end
    
    def it_should_apply_error_logic_for_input_type(type)
      describe 'when there are errors on the object for this method' do
        before do
          @title_errors = ['must not be blank', 'must be longer than 10 characters', 'must be awesome']
          @errors = mock('errors')
          @errors.stub!(:[]).with(:title).and_return(@title_errors)
          @new_post.stub!(:errors).and_return(@errors)
        end

        it 'should apply an errors class to the list item' do
          form = semantic_form_for(@new_post) do |builder|
            concat(builder.input(:title, :as => type))
          end
          output_buffer.concat(form) if Formtastic::Util.rails3?
          output_buffer.should have_tag('form li.error')
        end

        it 'should not wrap the input with the Rails default error wrapping' do
          form = semantic_form_for(@new_post) do |builder|
            concat(builder.input(:title, :as => type))
          end
          output_buffer.concat(form) if Formtastic::Util.rails3?
          output_buffer.should_not have_tag('div.fieldWithErrors')
        end

        it 'should render a paragraph for the errors' do
          ::Formtastic::SemanticFormBuilder.inline_errors = :sentence
          form = semantic_form_for(@new_post) do |builder|
            concat(builder.input(:title, :as => type))
          end
          output_buffer.concat(form) if Formtastic::Util.rails3?
          output_buffer.should have_tag('form li.error p.inline-errors')
        end

        it 'should not display an error list' do
          ::Formtastic::SemanticFormBuilder.inline_errors = :list
          form = semantic_form_for(@new_post) do |builder|
            concat(builder.input(:title, :as => type))
          end
          output_buffer.concat(form) if Formtastic::Util.rails3?
          output_buffer.should have_tag('form li.error ul.errors')
        end
      end

      describe 'when there are no errors on the object for this method' do
        before do
          @form = semantic_form_for(@new_post) do |builder|
            concat(builder.input(:title, :as => type))
          end
        end

        it 'should not apply an errors class to the list item' do
          output_buffer.concat(@form) if Formtastic::Util.rails3?
          output_buffer.should_not have_tag('form li.error')
        end

        it 'should not render a paragraph for the errors' do
          output_buffer.concat(@form) if Formtastic::Util.rails3?
          output_buffer.should_not have_tag('form li.error p.inline-errors')
        end

        it 'should not display an error list' do
          output_buffer.concat(@form) if Formtastic::Util.rails3?
          output_buffer.should_not have_tag('form li.error ul.errors')
        end
      end

      describe 'when no object is provided' do
        before do
          @form = semantic_form_for(:project, :url => 'http://test.host') do |builder|
            concat(builder.input(:title, :as => type))
          end
        end

        it 'should not apply an errors class to the list item' do
          output_buffer.concat(@form) if Formtastic::Util.rails3?
          output_buffer.should_not have_tag('form li.error')
        end

        it 'should not render a paragraph for the errors' do
          output_buffer.concat(@form) if Formtastic::Util.rails3?
          output_buffer.should_not have_tag('form li.error p.inline-errors')
        end

        it 'should not display an error list' do
          output_buffer.concat(@form) if Formtastic::Util.rails3?
          output_buffer.should_not have_tag('form li.error ul.errors')
        end
      end
    end
    
    def it_should_call_find_on_association_class_when_no_collection_is_provided(as)
      it "should call find on the association class when no collection is provided" do
        ::Author.should_receive(:find)
        form = semantic_form_for(@new_post) do |builder|
          concat(builder.input(:author, :as => as))
        end
      end
    end

    def it_should_use_the_collection_when_provided(as, countable)
      describe 'when the :collection option is provided' do

        before do
          @authors = ::Author.find(:all) * 2
          output_buffer.replace '' # clears the output_buffer from the before block, hax!
        end

        it 'should use the provided collection' do
          form = semantic_form_for(@new_post) do |builder|
            concat(builder.input(:author, :as => as, :collection => @authors))
          end
          output_buffer.concat(form) if Formtastic::Util.rails3?
          output_buffer.should have_tag("form li.#{as} #{countable}", :count => @authors.size + (as == :select ? 1 : 0))
        end

        describe 'and the :collection is an array of strings' do
          before do
            @categories = [ 'General', 'Design', 'Development', 'Quasi-Serious Inventions' ]
          end

          it "should use the string as the label text and value for each #{countable}" do
            form = semantic_form_for(@new_post) do |builder|
              concat(builder.input(:category_name, :as => as, :collection => @categories))
            end
            output_buffer.concat(form) if Formtastic::Util.rails3?

            @categories.each do |value|
              output_buffer.should have_tag("form li.#{as}", /#{value}/)
              output_buffer.should have_tag("form li.#{as} #{countable}[@value='#{value}']")
            end
          end

          if as == :radio
            it 'should generate a sanitized label for attribute' do
              @bob.stub!(:category_name).and_return(@categories)
              form = semantic_form_for(@new_post) do |builder|
                fields = builder.semantic_fields_for(@bob) do |bob_builder|
                  concat(bob_builder.input(:category_name, :as => as, :collection => @categories))
                end
                concat(fields)
              end
              output_buffer.concat(form) if Formtastic::Util.rails3?
              output_buffer.should have_tag("form li fieldset ol li label[@for='post_author_category_name_general']")
              output_buffer.should have_tag("form li fieldset ol li label[@for='post_author_category_name_design']")
              output_buffer.should have_tag("form li fieldset ol li label[@for='post_author_category_name_development']")
              output_buffer.should have_tag("form li fieldset ol li label[@for='post_author_category_name_quasiserious_inventions']")
            end
          end
        end

        describe 'and the :collection is a hash of strings' do
          before do
            @categories = { 'General' => 'gen', 'Design' => 'des','Development' => 'dev' }
          end

          it "should use the key as the label text and the hash value as the value attribute for each #{countable}" do
            form = semantic_form_for(@new_post) do |builder|
              concat(builder.input(:category_name, :as => as, :collection => @categories))
            end
            output_buffer.concat(form) if Formtastic::Util.rails3?

            @categories.each do |label, value|
              output_buffer.should have_tag("form li.#{as}", /#{label}/)
              output_buffer.should have_tag("form li.#{as} #{countable}[@value='#{value}']")
            end
          end
        end

        describe 'and the :collection is an array of arrays' do
          before do
            @categories = { 'General' => 'gen', 'Design' => 'des', 'Development' => 'dev' }.to_a
          end

          it "should use the first value as the label text and the last value as the value attribute for #{countable}" do
            form = semantic_form_for(@new_post) do |builder|
              concat(builder.input(:category_name, :as => as, :collection => @categories))
            end
            output_buffer.concat(form) if Formtastic::Util.rails3?

            @categories.each do |text, value|
              label = as == :select ? :option : :label
              output_buffer.should have_tag("form li.#{as} #{label}", /#{text}/i)
              output_buffer.should have_tag("form li.#{as} #{countable}[@value='#{value.to_s}']")
              output_buffer.should have_tag("form li.#{as} #{countable}#post_category_name_#{value.to_s}") if as == :radio
            end
          end
        end
        
        if as == :radio
          describe 'and the :collection is an array of arrays with boolean values' do
            before do
              @choices = { 'Yeah' => true, 'Nah' => false }.to_a
            end
        
            it "should use the first value as the label text and the last value as the value attribute for #{countable}" do
              form = semantic_form_for(@new_post) do |builder|
                concat(builder.input(:category_name, :as => as, :collection => @choices))
              end
              output_buffer.concat(form) if Formtastic::Util.rails3?
              
              output_buffer.should have_tag("form li.#{as} #{countable}#post_category_name_true")
              output_buffer.should have_tag("form li.#{as} #{countable}#post_category_name_false")
            end
          end
        end
        
        describe 'and the :collection is an array of symbols' do
          before do
            @categories = [ :General, :Design, :Development ]
          end

          it "should use the symbol as the label text and value for each #{countable}" do
            form = semantic_form_for(@new_post) do |builder|
              concat(builder.input(:category_name, :as => as, :collection => @categories))
            end
            output_buffer.concat(form) if Formtastic::Util.rails3?

            @categories.each do |value|
              label = as == :select ? :option : :label
              output_buffer.should have_tag("form li.#{as} #{label}", /#{value}/i)
              output_buffer.should have_tag("form li.#{as} #{countable}[@value='#{value.to_s}']")
            end
          end
        end
        
        describe 'and the :collection is an OrderedHash of strings' do
          before do
            @categories = ActiveSupport::OrderedHash.new('General' => 'gen', 'Design' => 'des','Development' => 'dev')
          end

          it "should use the key as the label text and the hash value as the value attribute for each #{countable}" do
            form = semantic_form_for(@new_post) do |builder|
              concat(builder.input(:category_name, :as => as, :collection => @categories))
            end
            output_buffer.concat(form) if Formtastic::Util.rails3?

            @categories.each do |label, value|
              output_buffer.should have_tag("form li.#{as}", /#{label}/)
              output_buffer.should have_tag("form li.#{as} #{countable}[@value='#{value}']")
            end
          end
          
        end
        
        describe 'when the :label_method option is provided' do
          
          describe 'as a symbol' do
            before do
              @form = semantic_form_for(@new_post) do |builder|
                concat(builder.input(:author, :as => as, :label_method => :login))
              end
            end

            it 'should have options with text content from the specified method' do
              output_buffer.concat(@form) if Formtastic::Util.rails3?
              ::Author.find(:all).each do |author|
                output_buffer.should have_tag("form li.#{as}", /#{author.login}/)
              end
            end
          end
          
          describe 'as a proc' do
            before do
              @form  = semantic_form_for(@new_post) do |builder|
                concat(builder.input(:author, :as => as, :label_method => Proc.new {|a| a.login.reverse }))
              end
            end
            
            it 'should have options with the proc applied to each' do
              output_buffer.concat(@form) if Formtastic::Util.rails3?
              ::Author.find(:all).each do |author|
                output_buffer.should have_tag("form li.#{as}", /#{author.login.reverse}/)
              end
            end
          end
          
        end

        describe 'when the :label_method option is not provided' do
          ::Formtastic::SemanticFormBuilder.collection_label_methods.each do |label_method|

            describe "when the collection objects respond to #{label_method}" do
              before do
                @fred.stub!(:respond_to?).and_return { |m| m.to_s == label_method || m.to_s == 'id' }
                ::Author.find(:all).each { |a| a.stub!(label_method).and_return('The Label Text') }

                @form = semantic_form_for(@new_post) do |builder|
                  concat(builder.input(:author, :as => as))
                end
              end

              it "should render the options with #{label_method} as the label" do
                output_buffer.concat(@form) if Formtastic::Util.rails3?
                ::Author.find(:all).each do |author|
                  output_buffer.should have_tag("form li.#{as}", /The Label Text/)
                end
              end
            end

          end
        end

        describe 'when the :value_method option is provided' do
          
          describe 'as a symbol' do
            before do
              @form = semantic_form_for(@new_post) do |builder|
                concat(builder.input(:author, :as => as, :value_method => :login))
              end
            end
            
            it 'should have options with values from specified method' do
              output_buffer.concat(@form) if Formtastic::Util.rails3?
              ::Author.find(:all).each do |author|
                output_buffer.should have_tag("form li.#{as} #{countable}[@value='#{author.login}']")
              end
            end
          end
          
          describe 'as a proc' do
            before do
              @form = semantic_form_for(@new_post) do |builder|
                concat(builder.input(:author, :as => as, :value_method => Proc.new {|a| a.login.reverse }))
              end
            end

            it 'should have options with the proc applied to each value' do
              output_buffer.concat(@form) if Formtastic::Util.rails3?
              ::Author.find(:all).each do |author|
                output_buffer.should have_tag("form li.#{as} #{countable}[@value='#{author.login.reverse}']")
              end
            end
          end
        end

      end
    end

  end
end