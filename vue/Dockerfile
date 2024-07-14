FROM php:8.2-fpm
#NVM install Node
RUN curl -o- 'https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh' | bash
RUN cd ~/../root/.nvm/ && bash nvm.sh && bash -l -c "nvm install 20"
#Node install Vue
RUN bash -l -c "npm install -g npm@10.8.1" && \
    bash -l -c "npm install -g @vue/cli" && \
    bash -l -c "npm install -g axios"
#Vue install
WORKDIR /app
# vue create .  (first create)
# npm run serve (link)[http://127.0.0.1:8080]