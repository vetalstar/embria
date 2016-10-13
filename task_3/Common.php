<?php

class Common implements SeekableIterator {

    private $fp;

    /**
     * Common constructor.
     * @param $filename
     * @param string $open_mode
     */
    public function __construct($filename, $open_mode = 'r')
    {
        if ( ! file_exists($filename))
            throw new CommonException('Файл ' . $filename . ' не существует');

        $this->fp = fopen($filename, $open_mode);

        if ( ! $this->fp)
            throw new CommonException('Невозможно открыть файл: ' . $filename);
    }

    /**
     * @return string
     * @throws CommonException
     */
    public function current()
    {
        $k = $this->key();
        $current = fgetc($this->fp);
        $this->seek($k);

        return $current;
    }

    /**
     * @throws CommonException
     */
    public function next()
    {
        $this->seek(1, SEEK_CUR);
    }

    /**
     * @return int
     * @throws CommonException
     */
    public function key()
    {
        $key = ftell($this->fp);

        if ($key === FALSE)
            throw new CommonException('Ошибка при получении текущей позиции');

        return $key;
    }

    /**
     * @return bool
     */
    public function valid()
    {
        return (bool) $this->current();
    }

    /**
     * @throws CommonException
     */
    public function rewind()
    {
        $rewind = rewind($this->fp);

        if ($rewind === FALSE)
            throw new CommonException('Ошибка при переводе в начало');
    }

    /**
     * @param int $offset
     * @param int $whence
     * @throws CommonException
     */
    public function seek($offset, $whence = SEEK_SET)
    {
        $fseek = fseek($this->fp, $offset, $whence);

        if ($fseek === -1)
            throw new CommonException('Ошибка при переводе указателя');
    }
}

class CommonException extends Exception {}


try
{
    $c = new Common('f.txt');
    $c->next();
    echo $c->current();
}
catch (CommonException $e)
{
    echo $e->getMessage();
}