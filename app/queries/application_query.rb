class ApplicationQuery
  def results
    raise NotImplementedError
  end

  # Return single result
  def result
    raise NotImplementedError
  end

  def sql
    raise NotImplementedError
  end
end
