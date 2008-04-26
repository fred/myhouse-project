ActionView::Helpers::InstanceTag.send :include, TextAreaWithStatus::InstanceTagExt
ActionView::Helpers::FormTagHelper.send :include, TextAreaWithStatus::FormTagHelperExt
ActionView::Helpers::AssetTagHelper.register_javascript_include_default('limit_chars')
