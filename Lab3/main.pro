﻿%Вариант - 1
%Долганов Ян Львович НПИбд-02-21
%НПИбд-02-21

implement main
    open core, file, stdio

domains
    год = integer.
    месяц = integer.
    день = integer.
    час = integer.
    жанр = драма; комедия; ужасы; фэнтези; криминал; фантастика; боевик; мюзикл; супергеройскийбоевик.
    минута = integer.
    date = date(год, месяц, день).
    time = time(час, минута).

class facts - movies
    %Факты Кинофильм (id, название, год выпуска, режиссер, жанр)
    фильм : (integer Id_фильма, string Название, integer Год, string Режиссер, жанр Жанр).
    %Факты Кинотеатр (id, название, адрес, телефон, количество мест)
    кинотеатр : (integer Id_кинотеатра, string Название, string Адрес, string Номер_телефона, integer Вместимость).
    %Факты Показывают (id кинотеатра, id фильма, дата, время, выручка)
    показывают : (integer Id_кинотеатра, integer Id_фильма, date Дата, time Время, integer Стоимость).

class facts
    s : (integer Сумма) single.

clauses
    s(0).

class predicates
    % Вывод всего списка
    data : (main::movies*) nondeterm.
    % Кинотеатр, в котором есть определенный фильм
    фильм_в_кинотеатре : (string Название_фильма) nondeterm.
    % Поиск кинотеатра, в котором фильм определенного жанра
    кинотеатр_по_жанру : (жанр Жанр) nondeterm.
    % Список фильмов с указанным жанром
    фильм_по_жанру : (жанр Жанр) -> main::movies* Фильм_по_жанру nondeterm.
    % Общая вместимость кинотеатров
    суммарная_вместимость : () -> integer Сумма.
    % Прибыль за билет по определенному фильму
    выручка_за_билет_по_фильму : (string Название_фильма) nondeterm.
    % Фильмы, снятые в конкретный год
    фильм_по_году : (integer Год) nondeterm.
    % Названия всех кинотеатров
    название_кинотеатра : () nondeterm.
    % Суммарная вместимость всех кинотеатров
    суммарная_вместимость : () nondeterm.
    % Максимальная цена билета
    максимальная_цена : () -> integer Максимальный determ.
    % Минимальная цена билета
    минимальная_цена : () -> integer Минимальный determ.
    % Длина всего списка
    длина : (Список*) -> integer Длина.
    % Максимальный элемент списка
    максимальный : (integer* Список, integer Максимальный [out]) nondeterm.
    % Среднее значение элементов списка
    среднее : (integer* Список) -> real Значение determ.
    % Минимальный элемент списка
    минимальный : (integer* Список, integer Минимальный [out]) nondeterm.
    % Сумма всех элементов списка
    сумма : (integer* Список) -> integer Сумма.

clauses
    фильм_по_жанру(Жанр) = ByGenre :-
        фильм(Id_фильма, Название, Год, Режиссер, Жанр),
        ByGenre = [ фильм(Id_фильма, Название, Год, Режиссер, Жанр) || фильм(Id_фильма, Название, Год, Режиссер, Жанр) ].
        % Вывод данных
    data([Для_вывода | Temp]) :-
        write(Для_вывода),
        nl,
        data(Temp).
    сумма([]) = 0.
    сумма([X_1 | Temp]) = сумма(Temp) + X_1.
    длина([]) = 0.
    длина([_ | Temp]) = длина(Temp) + 1.
    среднее(Список) = сумма(Список) / длина(Список) :-
        длина(Список) > 0.
    минимальный([Минимальный], Минимальный).
    минимальный([X_1, X_2 | Temp], Минимальный) :-
        X_1 <= X_2,
        минимальный([X_1 | Temp], Минимальный).
    минимальный([X_1, X_2 | Temp], Минимальный) :-
        X_1 > X_2,
        минимальный([X_2 | Temp], Минимальный).
    максимальный([Максимальный], Максимальный).
    максимальный([X_1, X_2 | Temp], Максимальный) :-
        X_1 >= X_2,
        максимальный([X_1 | Temp], Максимальный).
    максимальный([X_1, X_2 | Temp], Максимальный) :-
        X_1 < X_2,
        максимальный([X_2 | Temp], Максимальный).
    суммарная_вместимость() = Сумма :-
        Сумма = сумма([ Вместимость || кинотеатр(_, _, _, _, Вместимость) ]).

    максимальная_цена() = Результат :-
        максимальный([ Стоимость || показывают(_, _, _, _, Стоимость) ], Максимальный),
        Результат = Максимальный,
        !.

    минимальная_цена() = Результат :-
        минимальный([ Стоимость || показывают(_, _, _, _, Стоимость) ], Минимальный),
        Результат = Минимальный,
        !.

    кинотеатр_по_жанру(Жанр) :-
        показывают(Id_кинотеатра, Id_фильма, _, _, _),
        фильм(Id_фильма, _, _, _, Жанр),
        кинотеатр(Id_кинотеатра, _, Адрес, _, _),
        write("Адрес: ", Адрес),
        nl,
        fail.

    фильм_в_кинотеатре(Название_фильма) :-
        фильм(Id_фильма, Название_фильма, _, _, _),
        показывают(Id_кинотеатра, Id_фильма, _, _, Стоимость),
        кинотеатр(Id_кинотеатра, Название_кинотеатра, _, _, _),
        write("Кинотеатр: ", Название_кинотеатра, ", выручка: ", Стоимость),
        nl,
        fail.

    фильм_по_году(Год) :-
        фильм(_, Название_фильма, Год, _, _),
        write("Название фильма: ", Название_фильма),
        nl,
        fail.

    суммарная_вместимость() :-
        кинотеатр(_, _, _, _, Вместимость),
        s(Сумма),
        assert(s(Сумма + Вместимость)),
        fail.
    суммарная_вместимость() :-
        s(Сумма),
        write("Общая вместимость всех кинотеатров: ", Сумма),
        nl.

    выручка_за_билет_по_фильму(Название_фильма) :-
        фильм(Id_фильма, Название_фильма, _, _, _),
        показывают(Id_кинотеатра, Id_фильма, _, _, Стоимость),
        кинотеатр(Id_кинотеатра, Название_кинотеатра, _, _, _),
        write("Кинотеатр: ", Название_кинотеатра, ", выручка: ", Стоимость),
        nl,
        fail.

    название_кинотеатра() :-
        кинотеатр(_, Temp, _, _, _),
        write(Temp),
        nl,
        fail.

    run() :-
        console::initUtf8(),
        reconsult("../lab2text.txt", movies),
        write("Вывод фильмов с жанром фэнтези"),
        nl,
        Фильм_по_жанру = фильм_по_жанру(фэнтези),
        data(Фильм_по_жанру),
        nl,
        fail.

    run() :-
        console::initUtf8(),
        reconsult("../lab2text.txt", movies),
        write("Минимальная цена билета среди всех фильмов: ", минимальная_цена()),
        nl,
        fail.

    run() :-
        console::initUtf8(),
        reconsult("../lab2text.txt", movies),
        write("Максимальная цена билета среди всех фильмов: ", максимальная_цена()),
        nl,
        fail.

    run() :-
        console::initUtf8(),
        reconsult("../lab2text.txt", movies),
        write("Общая вместимость всех кинотеатров: ", суммарная_вместимость()),
        nl,
        fail.

    run() :-
        succeed.

end implement main

goal
    console::runUtf8(main::run).
