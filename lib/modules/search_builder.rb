module SearchBuilder
  def self.by_report_id(query, params)
    if params[:report_id].present?
      query = query.where(id: params[:report_id])
    end
    query
  end

  def self.by_country_of_discovery(query, params)
    if params[:country_of_discovery].present?
      query = query.where("data->'answers'->'country_of_discovery'->>'selected' in (?)", params[:country_of_discovery])
    end
    query
  end

  def self.by_date_created_range(query, params)
    if params[:to_date].present? && params[:from_date].present?
      from_date = self.to_datetime(params[:from_date]).beginning_of_day
      to_date   = self.to_datetime(params[:to_date]).end_of_day
      query     = query.where(created_at: from_date..to_date)
    end
    query
  end

  def self.by_agencies(query, params)
    if params[:agencies].present?
      agencies  = params[:agencies].map(&:to_i)
      query     = query.joins(:user).where(users: { agency_id: agencies })
    end
    query
  end

  def self.by_genus(query, params)
    fragments = []

    if params[:status_live].present?
      if params[:genus].present?
        # If you check the box for live, add a query to check for any genus type in that genus_live field
        fragments << "COALESCE(data->'genera'->'live', '[]') ?| array[:params]"
      else
        # If no specific genus selected, then return all reports where genus_live has a selected field that isnt empty (return all genus types)
        fragments << "data->'genera'->>'live' is not null and jsonb_array_length(data->'genera'->'live') > 0"
      end
    end

    if params[:status_dead].present?
      if params[:genus].present?
        fragments << "COALESCE(data->'genera'->'dead', '[]') ?| array[:params]"
      else
        fragments << "data->'genera'->>'dead' is not null and jsonb_array_length(data->'genera'->'dead') > 0"
      end
    end

    if params[:status_body_parts].present?
      if params[:genus].present?
        fragments << "COALESCE(data->'genera'->'parts', '[]') ?| array[:params]"
      else
        fragments << "data->'genera'->>'parts' is not null and jsonb_array_length(data->'genera'->'parts') > 0"
      end
    end

    # If none of the statuses are checked, treat it like all have been checked and add genus fragment for live dead and parts
    if params[:status_live].blank? && params[:status_dead].blank? && params[:status_body_parts].blank?
      if params[:genus].present?
        fragments << "COALESCE(data->'genera'->'live', '[]') ?| array[:params]"
        fragments << "COALESCE(data->'genera'->'dead', '[]') ?| array[:params]"
        fragments << "COALESCE(data->'genera'->'parts', '[]') ?| array[:params]"
      end
    end

    #Build the final query by joining the array
    sql   = fragments.join(" or ")
    query = query.where(sql, params: params[:genus])
    query
  end

  def self.by_users(query, params)
    if params[:users].present?
      users  = params[:users].map(&:to_i)
      query  = query.joins(:user).where(users: { id: users })
    end
    query
  end

  def self.by_ape_name(query, params)
    if params[:ape_name].present?
      query = query.where(
        """lower(data->'answers'->'individual_name_live'->>'selected') like lower(:params) or
        lower(data->'answers'->'individual_name_dead'->>'selected') like lower(:params)""", params: "%#{params[:ape_name]}%"
      )
    end
    query
  end

  def self.by_last_known_location(query, params)
    if params[:last_known_location].present?
      query = query.where(
        """data->'answers'->'last_known_location_live'->>'selected' in (:params) or
        data->'answers'->'last_known_location_dead'->>'selected' in (:params) or
        data->'answers'->'last_known_location_parts'->>'selected' in (:params)""", params: params[:last_known_location]
      )
    end
    query
  end

  # Helper methods
  def self.to_datetime(date_params)
    # Turns a date_select tag to a date object
    DateTime.new(
      date_params['(1i)'].to_i,
      date_params['(2i)'].to_i,
      date_params['(3i)'].to_i
    )
  end
end

