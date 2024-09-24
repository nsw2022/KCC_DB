-- �� ������ ������ ��ȸ�ؾ� �ȴ� ����

-- 1. ��ȸ�� �뼱�� �¼���ȣ�� ���ϴ� ����
-- 1-1 �����Ͽ��� �¼���ȣ���ִ���
-- 1-2 ��¥ 
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
    (s.schedule_end_time - s.schedule_start_time) * 24 * 60 AS required_time_minutes -- �ð� ���̸� �� ������ ���
FROM 
    route
JOIN
    schedule s ON s.route_id = route.route_id;

    
    
    --45��  ��� �ɾ߰�� �Ϲ� �Ϲݽɾ�  --28��� �ɾ߿��  --21 �����̾�  �ɾ������̾�
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


-- 2. ������� ������ �Ÿ��� ���ϴ� ���� (1������ ���ؿ��� �����)
