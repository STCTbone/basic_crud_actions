module BasicCrudActions
  module ActsAsCrud
    # mixed in crud controller actions, for a super light controller def!
    module ActionShortcuts
      using BasicCrudActions::ActsAsCrud::SaveReturnsStatusObjects
      def create
        set_instance_variable(new_model_source, create_params)
        instance_variable_get(instance_variable_name)
          .save(args_with_context).respond
      end

      def destroy
        model_source.call(params[:id]).destroy
        redirect_to action: 'index'
      end

      def edit
        find_model
      end

      def index
        instance_variable_set(instance_variable_name.pluralize,
                              models_source.call)
      end

      def update
        find_model
        instance_variable_get(instance_variable_name)
          .update_attributes(args_with_context(update_params)).respond
      end

      private

      def find_model
        set_instance_variable(model_source, params[:id])
      end

      def instance_variable_name
        "@#{class_name.underscore}"
      end

      def model_source
        model.public_method :find
      end

      def models_source
        model.public_method :all
      end

      def new_model_source
        model.public_method :new
      end

      def set_instance_variable(source, params)
        instance_variable_set(instance_variable_name, source.call(params))
      end
    end
  end
end
