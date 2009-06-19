class LabelFormBuilder < ActionView::Helpers::FormBuilder
  helpers = field_helpers + ['select'] - %w[hidden_field label fields_for text_area radio_button]

  helpers.each do |name|
    define_method(name) do |text, field, *args|
      p_class = args.last.delete(:p_class) if args.last.is_a?(::Hash)
      p_id = args.last.delete(:p_id) if args.last.is_a?(::Hash)
      @template.content_tag :p, :class => p_class, :id => p_id do
        label(field, text) +
        super(field, *args)
      end
    end
  end
end
