if @configuration[:environment] == "production"
  run "cd #{current_path}; rake ts:rebuild"
end