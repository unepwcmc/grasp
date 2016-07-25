module SearchBuilder
  def self.by_report_id(query, params)
    if params[:report_id].present?
      query.where(id: params[:report_id])
    end
    query
  end

  def self.by_country_of_discovery(query, params)
    if params[:country_of_discovery].present?
      query.where("""data->'questions'->'country_of_discovery'->>'selected' = ?""", params[:country_of_discovery])
    end
    query
  end

  def self.by_date_created_range(query, params)
    if params[:to_date].present? && params[:from_date].present?
      # Format the date_select tag to a date object
      f = params[:from_date]
      t = params[:to_date]
      from_date = DateTime.new(f['(1i)'].to_i, f['(2i)'].to_i, f['(3i)'].to_i).beginning_of_day
      to_date   = DateTime.new(t['(1i)'].to_i, t['(2i)'].to_i, t['(3i)'].to_i).end_of_day

      query.where(created_at: from_date..to_date)
    end
    query
  end

  def self.by_agencies(query, params)
    if params[:agencies].present?
      agencies = params[:agencies].map(&:to_i)
      query.joins(:user).where(users: { agency_id: agencies })
    end
    query
  end

  def self.by_genus(query, params)
    if params[:status_live].present?
      if params[:genus].present?
        query = query.where("""data->'questions'->'genus_live'->>'selected' in (?)""", params[:genus])
      else
        query = query.where("""(data->'questions'->'genus_live'->>'selected') is not null""")
      end
    end

    if params[:status_dead].present?
      if params[:genus].present?
        query = query.where("""data->'questions'->'genus_dead'->>'selected' in (?)""", params[:genus])
      else
        query = query.where("""(data->'questions'->'genus_dead'->>'selected') is not null""")
      end
    end

    if params[:status_body_parts].present?
      if params[:genus].present?
        query = query.where("""data->'questions'->'genus_body_parts'->>'selected' in (?)""", params[:genus])
      else
        query = query.where("""(data->'questions'->'genus_body_parts'->>'selected') is not null""")
      end
    end
    query
  end
end

