module ApplicationHelper
	def show_field_error(model,field)
		s=""

		if !model.errors[field].empty?
			s = 
			<<-EOHTML
			<div style="color:red" id="error_message">
				#{model.errors[field][0]}
			</div>
			EOHTML
		end

		s.html_safe
	end

	def current_class?(test_path)
		return 'active' if request.path == test_path
		''
	end
end
