class UrlClickPresenter < DelegateClass(UrlClick)
  def location
    @location ||= Locateable::Location.build(location_details['data'])
  end

  def address
    location.address
  end

  def ip
    location.ip
  end
end
