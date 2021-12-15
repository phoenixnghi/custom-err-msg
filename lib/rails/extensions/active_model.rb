# frozen_string_literal: true
# https://github.com/jeremydurham/custom-err-msg

# Usage:
# 1. Accept translated versions of attribute name:
# - Put your translated model attributes:
#  activerecord:
#    errors:
#      models:
#        attributes:
#          model_name:
#            attribute_name: 'Tên'
#
# Before: Name không được để trống
# Now:    Tên không được để trống
#
# 2. To omit the name of the attribute from error messages:
# - Put the carat symbol (^) in front of your custom error message:
#
#  contest_content:
#    attributes:
#      name:
#        blank: "^Vui lòng không để trống tên cuộc thi."
#
# Before: Name Vui lòng không để trống tên cuộc thi.
# Now:    Vui lòng không để trống tên cuộc thi.

module ActiveModel
  class Errors
    def full_messages
      full_messages = []

      each do |error|
        attribute = error.attribute
        messages  = error.message

        messages = Array.wrap(messages)
        next if messages.empty?

        if attribute == :base
          messages.each { |m| full_messages << m }
        else
          messages.each do |m|
            byebug
            full_messages << if m =~ /^\^/
                               m[1..-1]
                             else
                               if I18n.locale == :en
                                 "#{attribute.to_s.humanize} #{m}"
                               else
                                 attr_name = "activerecord.errors.models.attributes.#{@base.class.name.underscore}.#{attribute.to_s}"
                                 "#{I18n.t("#{attr_name}").to_s.humanize} #{m}"
                               end
                             end
          end
        end
      end

      full_messages
    end
  end
end
