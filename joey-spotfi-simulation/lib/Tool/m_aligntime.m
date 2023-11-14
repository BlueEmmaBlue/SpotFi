function ret = m_aligntime( time )
%M_ALIGNTIME find time alignment signal in time sequence
%   return first found time alignment signal position

    dt = diff(time);
    mdt = mean(dt);
    p = dt > mdt * 1.9;
    f = find( p==1 );
    df = diff(f);
    s = strfind(df, [1 2 ]);
    if numel(s) == 0
        ret = [];
    else
        ret = f(s);
    end
  %  disp('align position',ret);
end
