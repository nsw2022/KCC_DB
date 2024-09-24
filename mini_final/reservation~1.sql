-- 두 가지로 나누어 조회해야 된다 생각

-- 1. 조회된 노선의 좌석번호를 구하는 로직
-- 1-1 예약목록에서 좌석번호가있는지
-- 1-2 진짜 
SELECT 
    res.schedule_id,
    res.seat_number,
    ter_start.terminal_name AS start_terminal_name,
    ter_end.terminal_name AS end_terminal_name,
    bg.grade_name AS bus_grade
FROM
    reservation res
JOIN
    schedule sch ON res.schedule_id = sch.schedule_id
JOIN 
    route r ON sch.route_id = r.route_id
JOIN 
    terminal ter_start ON r.route_start_id = ter_start.terminal_id
JOIN 
    terminal ter_end ON r.route_end_id = ter_end.terminal_id
JOIN
    bus ON sch.bus_id = bus.bus_id
JOIN
    bus_grade bg ON bus.bus_id = bg.grade_id

WHERE
    res.schedule_id = 11;
    
select
    * 
from
    route 
join
    schedule s on s.route_id = route.route_id;
    
SELECT 
    route.route_id,
    s.schedule_id,
    (s.schedule_end_time - s.schedule_start_time) * 24 * 60 AS required_time_minutes -- 시간 차이를 분 단위로 계산
FROM 
    route
JOIN
    schedule s ON s.route_id = route.route_id;

    
    
    --45번  고속 심야고속 일반 일반심야  --28우등 심야우등  --21 프리미엄  심야프리미엄
    select * from bus;
    select * from bus_grade;
    select * from route;
    select * from reservation;
    select * from member;
    SELECT MAX(LENGTH(terminal_name)) AS max_length, terminal_name
    FROM terminal
    GROUP BY terminal_name
    ORDER BY max_length desc;


select * from terminal t INNER JOIN route rs 
ON t.terminal_id = rs.route_start_id INNER JOIN route re
ON t.terminal_id = re.route_end_id;

select * from member;


-- 2. 출발지와 도착지 거리를 구하는 로직 (1번에서 구해올지 고민중)
