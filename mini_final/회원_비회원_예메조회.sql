


-- 회원 예약 현황 쿼리문
SELECT 
    TO_CHAR(s.schedule_start_time, 'YY.MM.DD') AS schedule_date,
    TO_CHAR(s.schedule_start_time, 'HH24:MI:SS') AS start_time,
    TO_CHAR(s.schedule_end_time, 'HH24:MI:SS') AS schedule_end_time,
    ter_start.terminal_name AS start_terminal_name,
    ter_end.terminal_name AS end_terminal_name,
    res.seat_number,
    COUNT(res.member_seq) AS reservation_count,
    SUM(res.price) AS total_price
FROM 
    member m
JOIN 
    reservation res ON m.member_seq = res.member_seq
JOIN 
    schedule s ON res.schedule_id = s.schedule_id
JOIN 
    route r ON s.route_id = r.route_id
JOIN 
    TERMINAL ter_start ON r.route_start_id = ter_start.terminal_id
JOIN 
    TERMINAL ter_end ON r.route_end_id = ter_end.terminal_id
    
WHERE
    m.member_id = 'member1' and res.reservation_status = 1
GROUP BY
    r.route_start_id, 
    r.route_end_id,
    ter_start.terminal_name,
    ter_end.terminal_name,
    s.schedule_start_time, 
    s.schedule_end_time,
    res.seat_number;


-- 비회원 예약 현황 쿼리문
SELECT 
    TO_CHAR(s.schedule_start_time, 'YY.MM.DD') AS schedule_date,
    TO_CHAR(s.schedule_start_time, 'HH24:MI:SS') AS start_time,
    TO_CHAR(s.schedule_end_time, 'HH24:MI:SS') AS schedule_end_time,
    ter_start.terminal_name AS start_terminal_name,
    ter_end.terminal_name AS end_terminal_name,
    COUNT(res.reservation_id) AS reservation_count,
    SUM(res.price) AS total_price
FROM 
    non_user n
JOIN 
    reservation res ON n.non_user_code = res.non_user_code
JOIN 
    schedule s ON res.schedule_id = s.schedule_id
JOIN 
    route r ON s.route_id = r.route_id
JOIN 
    TERMINAL ter_start ON r.route_start_id = ter_start.terminal_id
JOIN 
    TERMINAL ter_end ON r.route_end_id = ter_end.terminal_id
WHERE
    n.non_user_tel = '010-7740-5366'
GROUP BY
    r.route_start_id, 
    r.route_end_id,
    ter_start.terminal_name,
    ter_end.terminal_name,
    s.schedule_start_time, 
    s.schedule_end_time;
    
    select * from TERMINAL;
    select * from reservation;
    select * from route;
    select * from member;