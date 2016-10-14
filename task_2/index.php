<?php

$db_host = 'localhost';
$db_user = 'v.kara';
$db_pass = 'reS23fdss65Z';
$db_name = 'embria';

$mysqli = new mysqli($db_host, $db_user, $db_pass, $db_name);

if ($mysqli->connect_errno)
{
    echo 'Не удалось подключиться: ' . $mysqli->connect_error;
    exit();
}

$limit = 10000;
$offset = 0;

$data = array();

do
{
    $sql = '
        SELECT
              `email`
        FROM
              `users`
        LIMIT ' . $limit . '
        OFFSET ' . $offset . '
    ';

    if( ! $result = $mysqli->query($sql))
    {
        $this->error('Не удалось выполнить запрос  ('. $sql .') ' . $mysqli->error);
        exit();
    }

    $emails = array();

    while($row = $result->fetch_assoc())
    {
        $emails[] = $row;
        $arr = explode(',', $row['email']);

        foreach($arr as $email)
        {
            $email = trim($email);

            if (empty($email))
                continue;

            $domain = trim(substr($email, (strpos($email, '@') + 1)));

            if (isset($data[$domain]))
            {
                $data[$domain] += 1;
            }
            else
            {
                $data[$domain] = 1;
            }
        }
    }

    $offset += $limit;
} while (sizeof($emails));

print_r($data);

$mysqli->close();