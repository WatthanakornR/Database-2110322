--complex query
SELECT *
FROM (
    SELECT C."coworking_id", C."name", C."address", COUNT(RS."reservation_id") AS total_reservations,
           DENSE_RANK() OVER (ORDER BY COUNT(RS."reservation_id") DESC) AS rank
    FROM "COWORKING_SPACE" C
    JOIN "ROOM" R ON C."coworking_id" = R."coworking_id"
    JOIN "RESERVATION" RS ON R."room_id" = RS."room_id"
    WHERE RS."start_time" >= '2025-02-05 14:00:00'
          AND RS."start_time" <= '2025-03-05 14:00:00'
    GROUP BY C."coworking_id", C."name", C."address"
) AS RankedSpaces
WHERE rank = 1;