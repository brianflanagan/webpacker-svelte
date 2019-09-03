require "test_helper"

module Webpacker
  module Svelte
    class ComponentTest < Minitest::Test
      include ERB::Util

      def setup
        @component = {
          name: "Hello",
          props: {
            name: "Svelte"
          }
        }
      end

      def test_it_outputs_a_div_element
        expected_html = <<-HTML.squish
          <div data-svelte-component=\"#{@component[:name]}\"
               data-svelte-props=\"#{escaped_props(@component[:props])}\"></div>
        HTML
        html = Webpacker::Svelte::Component.new(@component[:name])
                                          .render(@component[:props])

        assert_equal html, expected_html
      end

      def test_it_outputs_div_elements_in_series
        expected_html = "<div data-svelte-component=\"#{@component[:name]}\" data-svelte-props=\"#{escaped_props(@component[:props])}\"></div>" * 2

        html = Webpacker::Svelte::Component.new(@component[:name])
                                          .render(@component[:props])

        html += Webpacker::Svelte::Component.new(@component[:name])
                                          .render(@component[:props])

        assert_equal expected_html, html
      end

      def test_it_accepts_html_options
        html = Webpacker::Svelte::Component.new(@component[:name])
                                          .render(
                                            @component[:props],
                                            class: "class",
                                            id: "id"
                                          )

        assert(
          html.include?('class="class"') && html.include?('id="id"'),
          "it includes HTML options"
        )
      end

      def test_it_accepts_tag_option
        html = Webpacker::Svelte::Component.new(@component[:name])
                                          .render(
                                            @component[:props],
                                            tag: "span"
                                          )

        assert(
          html.include?("<span data-svelte-component="), "it outputs a span"
        )
      end

      private

        def escaped_props(props)
          html_escape(json_escape(props.to_json))
        end
    end
  end
end
