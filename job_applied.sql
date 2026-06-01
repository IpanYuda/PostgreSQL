CREATE TABLE job_applied (
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN, 
    resume_file_name VARCHAR(255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    status VARCHAR(50)
);

SELECT *
FROM job_applied;

INSERT INTO job_applied
            (job_id,
            application_sent_date,
            custom_resume,
            resume_file_name,
            cover_letter_sent,
            cover_letter_file_name,
            status)
VALUES      (1,
            '2024-02-01',
            true,
            'resume_01.pdf',
            true,
            'cover_letter_01.pdf',
            'submitted'),
            (2,
            '2024-02-02',
            false,
            'resume_02.pdf',
            false,
            NULL,
            'interview scheduled'),
            (3,
            '2024-02-03',
            true,
            'resume_03.pdf',
            true,
            'cover_letter_03.pdf',
            'ghosted'),
            (4,
            '2024-02-04',
            true,
            'resume_04.pdf',
            false,
            NULL,
            'submitted'),
            (5,
            '2024-02-05',
            false,
            'resume_05.pdf',
            true,
            'cover_letter_05.pdf',
            'rejected');

/* ALTER TABLE digunakan untuk mengedit tabel
perintah yang dapat dilakukan yaitu
ADD column_name datatype                        #menambahkan kolom baru
RENAME COLUMN column_name TO new_name           #mengubah nama kolom
ALTER COLUMN column_name TYPE  datatype         #mengubah datatype
DROP COLUMN column_name                         #menghilangkan kolom
*/

ALTER TABLE job_applied
ADD contact VARCHAR(50);

/* UPDATE digunakan untuk mengubah atau memperbarui data
yang sudah ada
UPDATE table_name
SET column_name = new_value     #new_value merupakan nilai baru yang ditmbahkan
WHERE condition                 #Menentukan baris/rekord spesifik mana yang datanya akan diperbarui.
*/

UPDATE job_applied
SET contact = 'Rafi'
WHERE job_id = 1;


UPDATE job_applied
SET contact = 'Alig'
WHERE job_id = 2;


UPDATE job_applied
SET contact = 'Fira'
WHERE job_id = 3;


UPDATE job_applied
SET contact = 'Arif'
WHERE job_id = 4;


UPDATE job_applied
SET contact = 'Iraf'
WHERE job_id = 5;

ALTER TABLE job_applied
DROP COLUMN contact;

DROP TABLE job_applied;