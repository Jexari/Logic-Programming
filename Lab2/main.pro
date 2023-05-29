%Вариант - 1
%Долганов Ян Львович (1032216531)
%НПИбд-02-21

implement main
    open core, file, stdio

domains
    year = integer.
    month = integer.
    day = integer.
    genre = драма; комедия; ужасы; фэнтези; криминал; фантастика; боевик; мюзикл; супергеройскийбоевик.
    minute = integer.
    hour = integer.
    date = date(year, month, day).
    time = time(hour, minute).

class facts - films
    %Факты Кинофильм (id, название, год выпуска, режиссер, жанр)
    фильм : (integer Id_m, string Name_m, integer Year, string Director, genre FilmGenre).
    %Факты Кинотеатр (id, название, адрес, телефон, количество мест)
    кинотеатр : (integer Id_c, string Name_c, string Address, string Phone, integer Capacity).
    %Факты Показывают (id кинотеатра, id фильма, дата, время, выручка)
    показывают : (integer Id_c, integer Id_m, date Date, time Time, integer Price).

class predicates
    % Фильмы, снятые в определенный год
    фильм_по_году : (integer Year) nondeterm.
    % Названия всех кинотеатров
    название_кинотеатра : () nondeterm.
    % Кинотеатр, в котором есть определенный фильм
    фильм_в_кинотеатре : (string Name_temp) nondeterm.
    %  Адрес кинотеатра, в котором показывается определннный жанр
    адрес_по_жанру : (genre Genre) nondeterm.
    % Суммарная вместимость всех кинотеатров
    вместимость_в_сумме : () nondeterm.
    % Выручка кинотеатра билет на фильм
    цена_билета_за_фильм : (string Name_temp) nondeterm.
    % Определяет на адрес кинотеатра по названию
    адрес_кинотеатра : (string Name) nondeterm.

class facts
    s : (integer Sum) single.

clauses
    s(0).

clauses
    адрес_по_жанру(Genre) :-
        показывают(Id_c, Id_m, _, _, _),
        фильм(Id_m, _, _, _, Genre),
        кинотеатр(Id_c, _, Address, _, _),
        write("Адрес: ", Address),
        nl,
        fail.

    адрес_кинотеатра(Name) :-
        кинотеатр(_, Name, Address, _, _),
        write("Адрес: ", Address),
        nl,
        fail.

    фильм_в_кинотеатре(Name_temp) :-
        фильм(Id_m, Name_temp, _, _, _),
        показывают(Id_c, Id_m, _, _, Price),
        кинотеатр(Id_c, Name_c, _, _, _),
        write("Кинотеатр: ", Name_c, ", выручка: ", Price),
        nl,
        fail.

    фильм_по_году(Year) :-
        фильм(_, Name_temp, Year, _, _),
        write("Название фильма: ", Name_temp),
        nl,
        fail.

    цена_билета_за_фильм(Name_temp) :-
        фильм(Id_m, Name_temp, _, _, _),
        показывают(Id_c, Id_m, _, _, Price),
        кинотеатр(Id_c, Name_c, _, _, _),
        write("Кинотеатр: ", Name_c, ", выручка: ", Price),
        nl,
        fail.

    название_кинотеатра() :-
        кинотеатр(_, Name_Cinema, _, _, _),
        write(Name_Cinema),
        nl,
        fail.

    вместимость_в_сумме() :-
        кинотеатр(_, _, _, _, Temp1),
        s(Sum),
        assert(s(Sum + Temp1)),
        fail.

    вместимость_в_сумме() :-
        s(Sum),
        write("Общая вместимость всех кинотеатров: ", Sum),
        nl.

    run() :-
        console::init(),
        reconsult("../lab2text.txt", films),
        write("Кинотеатры в базе данных:"),
        nl,
        название_кинотеатра(),
        fail.

    run() :-
        console::init(),
        reconsult("../lab2text.txt", films),
        write("Введите год, чтобы узнать, какие фильмы в нем были сняты: "),
        nl,
        Temp = read(),
        фильм_по_году(Temp),
        nl,
        fail.

    run() :-
        console::init(),
        reconsult("../lab2text.txt", films),
        write("Введите жанр фильма: "),
        Temp = read(),
        Temp = hasDomain(genre, Temp),
        адрес_по_жанру(Temp),
        nl,
        fail.

    run() :-
        console::init(),
        reconsult("../lab2text.txt", films),
        write("Введите название кинотеатра (в двойных кавычках): "),
        Name = read(),
        Name = hasDomain(string, Name),
        адрес_кинотеатра(Name),
        nl,
        fail.

    run() :-
        console::init(),
        reconsult("../lab2text.txt", films),
        write("Цены билетов на фильм 'Служебный роман': "),
        nl,
        цена_билета_за_фильм("Служебный роман"),
        nl,
        fail.

    run() :-
        console::init(),
        reconsult("../lab2text.txt", films),
        вместимость_в_сумме(),
        nl,
        fail.

    run() :-
        succeed.

end implement main

goal
    console::runUtf8(main::run).
