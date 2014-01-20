module Jibe
  class ModelWorker < Worker
    def perform system, model_name, action, encrypted_string
      data = Jibe.decrypt_and_decompress encrypted_string
      model_class = model_name.classify.constantize
      model_class.run_hook :"jibe_on_#{action}", data
    end
  end
end
