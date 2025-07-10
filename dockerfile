# Add pink ASCII art
RUN echo "printf '\n\033[38;5;205m" >> /root/.bashrc && \
    echo "  ____       _   _   _     _   \n" >> /root/.bashrc && \
    echo " |  _ \ ___ | |_| |_| |__ (_)_ __  \n" >> /root/.bashrc && \
    echo " | |_) / _ \| __| __| '_ \| | '_ \ \n" >> /root/.bashrc && \
    echo " |  __/ (_) | |_| |_| | | | | | | |\n" >> /root/.bashrc && \
    echo " |_|   \___/ \__|\__|_| |_|_|_| |_|\n\033[0m'" >> /root/.bashrc
