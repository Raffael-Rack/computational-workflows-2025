params.step = 0
params.zip = 'zip'


process SAYHELLO {
    debug true

    output:
        stdout

    script:
    """
    echo "HELLO WORLD!"
    """
}

process SAYHELLO_PYTHON {
    debug true

    output:
        stdout

    script:
    """
    #!/usr/bin/env python
    print("HELLO WORLD!")
    """
}

process SAYHELLO_PARAM {
    debug true
    
    input:
        val greeting

    output:
        stdout

    script:
        """
        echo "$greeting"
        """
}

process SAYHELLO_FILE {
    input:
        val greeting

    output:
        path "greeting.txt"

    script:
    """
    echo $greeting > greeting.txt
    """
}

process UPPERCASE {
    publishDir "/workspaces/computational-workflows-2025/notebooks/day_04"

    input:
        val greeting

    output:
        path "GREETING.txt"

    script:
    """
    echo $greeting | tr "[a-z]" "[A-Z]" > GREETING.txt
    """
}

process PRINTUPPER {
    debug true

    input:
        path file

    output:
        stdout

    script:
    """
    cat $file | xargs echo
    """

}

process ZIPPER {
    debug true

    input:
        path file

    output:
        path "*.zip"

    script:
    """
    zip ${file}.zip ${file}
    """
}

process ZIPPER_ALL {
    debug true

    input:
        path file

    output:
        tuple (path "*.zip"), (path "*.gz"), (path "*.bz2")

    script:
        """
        zip ${file}.zip ${file}
        gzip -c ${file} > ${file}.gz
        bzip2 -c ${file} > ${file}.bz2
        """
}

process TASK_9 {
    publishDir "/workspaces/computational-workflows-2025/notebooks/day_04/results", mode: "copy"

    input:
        val data

    output: 
        path "names.tsv"

    script:
        def output_file = new File("names.tsv") 
        //output_file.createNewFile()
        def names = data["name"]
        def titles = data["title"]
        
        """
        echo $names > $output_file
        echo $titles >> $output_file
        """

}

workflow {

    // Task 1 - create a process that says Hello World! (add debug true to the process right after initializing to be sable to print the output to the console)
    if (params.step == 1) {
        SAYHELLO()
    }

    // Task 2 - create a process that says Hello World! using Python
    if (params.step == 2) {
        SAYHELLO_PYTHON()
    }

    // Task 3 - create a process that reads in the string "Hello world!" from a channel and write it to command line
    if (params.step == 3) {
        greeting_ch = Channel.of("Hello world!")
        SAYHELLO_PARAM(greeting_ch)
    }

    // Task 4 - create a process that reads in the string "Hello world!" from a channel and write it to a file. WHERE CAN YOU FIND THE FILE?
    if (params.step == 4) {
        greeting_ch = Channel.of("Hello world!")
        SAYHELLO_FILE(greeting_ch)
    }

    // Task 5 - create a process that reads in a string and converts it to uppercase and saves it to a file as output. View the path to the file in the console
    if (params.step == 5) {
        greeting_ch = Channel.of("Hello world!")
        out_ch = UPPERCASE(greeting_ch)
        out_ch.view()
    }

    // Task 6 - add another process that reads in the resulting file from UPPERCASE and print the content to the console (debug true). WHAT CHANGED IN THE OUTPUT?
    if (params.step == 6) {
        greeting_ch = Channel.of("Hello world!")
        out_ch = UPPERCASE(greeting_ch)
        PRINTUPPER(out_ch)
    }

    
    // Task 7 - based on the paramater "zip" (see at the head of the file), create a process that zips the file created in the UPPERCASE process either in "zip", "gzip" OR "bzip2" format.
    //          Print out the path to the zipped file in the console
    if (params.step == 7) {
        greeting_ch = Channel.of("Hello world!")
        uppercase_ch = UPPERCASE(greeting_ch)
        out_ch = ZIPPER(uppercase_ch)
        out_ch.view()
    }

    // Task 8 - Create a process that zips the file created in the UPPERCASE process in "zip", "gzip" AND "bzip2" format. Print out the paths to the zipped files in the console

    if (params.step == 8) {
        greeting_ch = Channel.of("Hello world!")
        uppercase_ch = UPPERCASE(greeting_ch)
        out_ch = ZIPPER_ALL(uppercase_ch).flatten().view()
    }

    // Task 9 - Create a process that reads in a list of names and titles from a channel and writes them to a file.
    //          Store the file in the "results" directory under the name "names.tsv"

    if (params.step == 9) {
        in_ch = channel.of(
            ['name': 'Harry', 'title': 'student'],
            ['name': 'Ron', 'title': 'student'],
            ['name': 'Hermione', 'title': 'student'],
            ['name': 'Albus', 'title': 'headmaster'],
            ['name': 'Snape', 'title': 'teacher'],
            ['name': 'Hagrid', 'title': 'groundkeeper'],
            ['name': 'Dobby', 'title': 'hero'],
        )

        out_ch = TASK_9(in_ch.collect()).view()
    }

}