namespace cnma.callofflines.views;

using {cnma.callofflines as cnma} from './CallOffLines';

view Last3CallOffs as
    select *
    from cnma.CallOffLines
    order by callOffLine asc, callOffId desc
    limit 3;