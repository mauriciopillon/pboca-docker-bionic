#!/bin/bash
ssh -fN bocaDB
cd autojudge-bin/src-minimal/
php private/autojudging.php
