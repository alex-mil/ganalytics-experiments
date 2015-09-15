module GAnalytics
  module Validator
    def validate_required_arguments(properties, method_name)
      valid = case method_name
                  when /start/i then
                    properties[:code].present? && properties[:experiment].present? &&
                      properties[:experiment][:name].present? && properties[:experiment][:status].present? &&
                        properties[:experiment][:variations].length > 0
                  when /stop/i then
                    properties[:refresh_token].present? && properties[:experiment_id].present? &&
                      properties[:experiment].present? && properties[:experiment][:id].present? &&
                        properties[:experiment][:status].present?
                  when /load/i then
                    properties[:refresh_token].present? && properties[:experiment_id].present?
                  else
                    false
                 end
      
      raise exception("#{File.basename __FILE__}:#{__LINE__}: missing required properties in '#{method_name}' action") unless valid
    end
  end
end