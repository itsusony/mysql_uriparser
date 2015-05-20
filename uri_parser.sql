CREATE FUNCTION `DATABASE`.`uri_parser`(_key varchar(128), _txt longtext)
RETURNS longtext
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY INVOKER
COMMENT ''
begin
	declare _rtn longtext default "";
	declare left_pos int default -1;
	declare left_pos2 int default -1;
	if( _key is not null and length(_key)>0 and _txt is not null and length(_txt)>0 and _txt regexp concat(_key,"=") = 1) then
		select locate(_key,_txt) into left_pos;
		if(left_pos >= 0) then
			set left_pos = left_pos+length(_key)+1;
			select substr(_txt,left_pos) into _rtn;
			if( _rtn regexp "^[0-9]+(.*)$" ) then
				select locate('&',_rtn) into left_pos2;
				if(left_pos2 > 0) then
					select substr(_rtn,1,left_pos2-1) into _rtn;
				end if;
			else
				set _rtn = "";
			end if;
		end if;
	end if;
	return _rtn;
end
